import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';
import 'package:store/src/model/book.dart';

class BookBloc {
  final _name = BehaviorSubject<String>();
  final _category = BehaviorSubject<String>();
  final _content = BehaviorSubject<String>();
  final _importPrice = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _amount = BehaviorSubject<String>();
  final _author = BehaviorSubject<String>();
  final _image = BehaviorSubject<String>();
  final _search = BehaviorSubject<String>();
  final _ids = BehaviorSubject<String>();
  final _id = FirebaseFirestore.instance.collection('Book').doc().id;

  void dispose() {
    _author.close();
    _category.close();
    _content.close();
    _image.close();
    _importPrice.close();
    _name.close();
    _price.close();
    _amount.close();
    _search.close();
  }

  Stream<String> get name => _name.stream.transform(_validate);
  Stream<String> get category => _category.stream.transform(_validate);
  Stream<String> get content => _content.stream.transform(_validate);
  Stream<String> get importPrice => _importPrice.stream.transform(_validate);
  Stream<String> get price => _price.stream.transform(_validate);
  Stream<String> get amount => _amount.stream.transform(_validate);
  Stream<String> get author => _author.stream.transform(_validate);
  Stream<String> get image => _image.stream.transform(_validateImage);

  Function(String) get valueName => _name.sink.add;
  Function(String) get valueAuthor => _author.sink.add;
  Function(String) get valueCategory => _category.sink.add;
  Function(String) get valueContent => _content.sink.add;
  Function(String) get valueImportPrice => _importPrice.sink.add;
  Function(String) get valuePrice => _price.sink.add;
  Function(String) get valueAmount => _amount.sink.add;
  Function(String) get valueIds => _ids.sink.add;

  String? get valueImages => _image.valueOrNull;
  String? get valueCate => _category.valueOrNull;

  final _validate = StreamTransformer<String, String>.fromHandlers(
      handleData: (data, sink) => {
            if (data != null) {sink.add(data.toString())},
          });

  final _validateImage = StreamTransformer<String, String>.fromHandlers(
      handleData: (image, sink) => {
            sink.add(image),
          });

  Future imagePicker(ImageSource source) async {
    final images = await ImagePicker().pickImage(source: source);
  }

  Future addImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    // print('${file?.path}');

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));

      return _image.value = await referenceImageToUpload.getDownloadURL();

    } catch (error) {
      print(error);
    }
  }

  addBook(BuildContext context) async {
    final int amounts = int.parse(_amount.value);
    final int totals = int.parse(_importPrice.value);
    final String total = (amounts * totals).toString();
    final book = BookModel(
        id: _id,
        name: _name.value,
        author: _author.value,
        category: _category.value,
        content: _content.value,
        createAt: DateTime.now().toString(),
        image: _image.value,
        importPrice: _importPrice.value,
        amount: _amount.value,
        total: total,
        price: _price.value);

    await FirebaseFirestore.instance
        .collection('Book')
        .doc(_id)
        .set(book.toJson());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Thêm sách thành công')));
  }

  Stream<QuerySnapshot> get getBook {
    return FirebaseFirestore.instance.collection('Book').snapshots();
  }

  Stream<QuerySnapshot> get getCateBook {
    return FirebaseFirestore.instance
        .collection('Book')
        .where("category", isEqualTo: valueCate)
        .snapshots();
  }

  Future deleteBook() async {
    await FirebaseFirestore.instance.collection('Book').doc(_ids.value).delete();
  }
}

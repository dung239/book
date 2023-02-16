import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:store/src/model/category.dart';

class CategoryBloc {
  final _category = BehaviorSubject<String>();
  final _ids = BehaviorSubject<String>();
  final _db = FirebaseFirestore.instance;
  final _id = FirebaseFirestore.instance.collection('Category').doc().id;

  void dispose() {
    _category.close();
  }

  Stream get category => _category.stream.transform(_validateCategory);
  Stream get ids => _ids.stream;

  Function(String) get valueCategory => _category.sink.add;
  Function(String) get valueId => _ids.sink.add;

  final _validateCategory = StreamTransformer<String, String>.fromHandlers(
    handleData: (category, sink) => sink.add(category.toString()),
  );

  Future addCategory() async {
    final cate = CategoryModel(
        id: _id,
        category: _category.value,
        categoryId: _db.collection('Category').doc().id.toString());
    await _db.collection('Category').doc(_id).set(cate.toJson());
  }

  Future deleteCate() async {
    await _db.collection('Category').doc(_ids.value).delete();
  }

  Stream<QuerySnapshot> get getCategory {
    return _db.collection('Category').snapshots();
  }
}

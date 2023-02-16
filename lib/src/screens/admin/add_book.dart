import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/src/bloc/bookBloc.dart';
import 'package:store/src/bloc/categoryBloc.dart';
import 'package:store/src/screens/cartScreen.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final bloc = BookBloc();
  final blocCate = CategoryBloc();

  // Future imagePicker(ImageSource source) async {
  //   final image = await ImagePicker().pickImage(source: source);
  // }

  @override
  dispose() {
    bloc.dispose();
    blocCate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sách'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 00, 20, 0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: [
              StreamBuilder(
                  stream: bloc.image,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: () {
                        bloc.addImage();
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Profile Picture Uploaded')));
                        });
                      },
                      child: SizedBox(
                        child: Container(child: 
                         (bloc.valueImages.toString() != "null")
                            ? 
                            Image.network(
                                bloc.valueImages.toString(),
                                height: 250,
                                width: 200,
                              )
                            : Image.asset('assets/images/camera.png'),
                        )
                      ),
                    );
                  }),

              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.name,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: (value) => bloc.valueName(value),
                      decoration: InputDecoration(
                          labelText: 'Tên sách',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: blocCate.getCategory,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                          child: Text('Some error occurred ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      List<QueryDocumentSnapshot> documents =
                          querySnapshot.docs;
                      List<Map<String, dynamic>> items = documents
                          .map((e) => {
                                // 'id': e.id,
                                'category': e['category'],
                                'categoryId': e['categoryId']
                              })
                          .toList();
                      return DropdownFormField<Map<String, dynamic>>(
                        onEmptyActionPressed: () async {},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: "Thể loại"),
                        displayItemFn: (dynamic item) => Text(
                          (item ?? {})['category'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                        findFn: (dynamic str) async => items,
                        filterFn: (dynamic item, str) =>
                            item['category']
                                .toLowerCase()
                                .indexOf(str.toLowerCase()) >=
                            0,
                        dropdownItemFn: (dynamic item,
                                int position,
                                bool focused,
                                bool selected,
                                Function() onTap) =>
                            ListTile(
                          title: Text(item['category']),
                          tileColor: focused
                              ? Color.fromARGB(20, 0, 0, 0)
                              : Colors.transparent,
                          onTap: () {
                            onTap();
                            setState(() {
                              // categoryId = item['categoryId'];
                              bloc.valueCategory(item['categoryId']);
                            });
                          },
                        ),
                      );
                    }
                    return Container(child: CircularProgressIndicator());
                  }),

              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.author,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: (value) => bloc.valueAuthor(value),
                      decoration: InputDecoration(
                          labelText: 'Tác giả',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.content,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: (value) => bloc.valueContent(value),
                      decoration: InputDecoration(
                          labelText: 'Nội dung',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                      maxLines: null,
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.importPrice,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: (value) => bloc.valueImportPrice(value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Giá nhập',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                      maxLines: null,
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.price,
                  builder: (context, snapshot) {
                    return TextFormField(
                      onChanged: (value) => bloc.valuePrice(value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Giá bán',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                      maxLines: null,
                    );
                  }),
                  SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: bloc.price,
                  builder: (context, snapshot) {
                    return TextFormField(
                      onChanged: (value) => bloc.valueAmount(value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Số lượng',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                      maxLines: null,
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)))),
                    onPressed: () => bloc.addBook(context),
                    child: Text(
                      'Thêm sách',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}

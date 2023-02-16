import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/categoryBloc.dart';
import 'package:store/src/model/category.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final bloc = CategoryBloc();

  @override
  dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thể loại')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StreamBuilder(
                stream: bloc.category,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: (value) => bloc.valueCategory(value),
                    decoration: InputDecoration(
                        labelText: 'Thể loại',
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40))),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: (() => bloc.addCategory()),
                  child: Text(
                    'Thêm thể loại',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))))),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: bloc.getCategory,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                        child: Text('Some error occurred ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                    List<CategoryModel> items = documents
                        .map(
                          (e) => CategoryModel(
                              id: e['id'],
                              category: e['category'],
                              categoryId: e['categoryId']),
                        )
                        .toList();
                    return Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> thisItem = items[index].toJson();
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${thisItem['category']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(Icons.delete),
                                    onDoubleTap: () {
                                      setState(() {
                                        bloc.valueId!(thisItem['id']);
                                      });
                                      bloc.deleteCate();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Container(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}

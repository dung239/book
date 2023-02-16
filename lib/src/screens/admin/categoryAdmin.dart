import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/bookBloc.dart';
import 'package:store/src/bloc/categoryBloc.dart';
import 'package:store/src/model/book.dart';
import 'package:store/src/screens/admin/infoBook.dart';

class CategoryAdmin extends StatefulWidget {
  const CategoryAdmin({super.key});

  @override
  State<CategoryAdmin> createState() => _CategoryAdminState();
}

class _CategoryAdminState extends State<CategoryAdmin> {
  final blocCate = CategoryBloc();
  final bloc = BookBloc();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thể loại')),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: blocCate.getCategory,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      child: Text('Some error occurred ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                  List<Map<String, dynamic>> items = documents
                      .map((e) => {
                            // 'id': e.id,
                            'category': e['category'],
                            'categoryId': e['categoryId']
                          })
                      .toList();
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownFormField<Map<String, dynamic>>(
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
                      dropdownItemFn: (dynamic item, int position, bool focused,
                              bool selected, Function() onTap) =>
                          ListTile(
                        title: Text(item['category']),
                        tileColor: focused
                            ? Color.fromARGB(20, 0, 0, 0)
                            : Colors.transparent,
                        onTap: () {
                          onTap();
                          setState(() {
                            bloc.valueCategory!(item['categoryId']);
                          });
                        },
                      ),
                    ),
                  );
                }
                return Container(child: CircularProgressIndicator());
              }),
          Expanded(
            child: StreamBuilder(
                stream: (bloc.valueCate != "null")
                    ? bloc.getCateBook
                    : bloc.getBook,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                        child: Text('Some error occurred ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                    List<BookModel> books = docs
                        .map(((e) => BookModel(
                              id: e['id'],
                              name: e['name'],
                              author: e['author'],
                              category: e['category'],
                              content: e['content'],
                              createAt: e['createAt'],
                              image: e['image'],
                              importPrice: e['importPrice'],
                              price: e['price'],
                              total: e['total'],
                              amount: e['amount'],
                            )))
                        .toList();
                    return Container(
                        child: GridView.builder(
                      itemCount: books.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Map item = books[index].toJson();
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InfoBook(item: books[index])));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  '${item['image']}',
                                  fit: BoxFit.fill,
                                  height: 130,
                                  width: 130,
                                ),
                                Text(
                                  item['name'],
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Giá: ${item['price']} đ',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
                  }
                  // }
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/bookBloc.dart';
import 'package:store/src/model/book.dart';
import 'package:store/src/screens/admin/infoBook.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomePageAdmin> {
  final bloc = BookBloc();
  String _search = '';
  TextEditingController search = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: [
          AnimSearchBar(
              width: 270,
              textController: search,
              onSuffixTap: () {
                setState(() {
                  search.clear();
                });
              },
              onSubmitted: (value) {
                setState(() {
                  value = search.text.toString();
                  _search = value;
                });
              }),
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: bloc.getBook,
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text('Đã xảy ra lỗi'),
                  );
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data;
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

                  if (_search == '') {
                    List<BookModel> items = books;
                    return Container(
                        child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Map item = items[index].toJson();
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
                                  'Giá: ${int.parse(item['price']).toStringAsFixed(0)} đ'
                                      .replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (match) => '${match[1]}.'),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
                  } else {
                    List<BookModel> items = books.where((e) {
                      final bookName = e.name.toLowerCase();
                      final search = _search.toString();
                      return bookName.contains(search);
                    }).toList();

                    return Container(
                        child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Map item = items[index].toJson();
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
                                  'Giá: ${int.parse(item['price']).toStringAsFixed(0)} đ'
                                      .replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (match) => '${match[1]}.'),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
                  }
                }
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }),
            ),
          ),
        ],
      )),
    );
  }
}

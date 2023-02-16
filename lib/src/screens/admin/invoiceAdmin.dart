import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/model/book.dart';
import 'package:store/src/model/invoice.dart';

class InvoiceAdmin extends StatefulWidget {
  const InvoiceAdmin({super.key});

  @override
  State<InvoiceAdmin> createState() => _InvoiceAdminState();
}

class _InvoiceAdminState extends State<InvoiceAdmin> {
  List<String> items = ['Đơn hàng', 'Nhập hàng'];
  String _itemDropdown = 'Đơn hàng';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê')),
      body: Container(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton(
                items: items.map((e) {
                  return DropdownMenuItem(
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 18),
                    ),
                    value: e,
                  );
                }).toList(),
                value: _itemDropdown,
                onChanged: ((value) {
                  setState(() {
                    _itemDropdown = value!;
                  });
                })),
          ),
          _itemDropdown == 'Đơn hàng'
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Invoice')
                          .snapshots(),
                      builder: ((context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data;
                          List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                          List<InvoiceModel> invoices = docs
                              .map(((e) => InvoiceModel(
                                  // id: e['id'],
                                  // invoice: e.get('invoice')['invoice'],
                                  // userId: e['userId'],
                                  // total: e['total'],
                                  // profit: e['profit'],
                                  // createAt: e['createAt'])))
                                  id: e.get('id'),
                                  invoice: e.get('invoice'),
                                  userId: e.get('userId'),
                                  total: e['total'],
                                  profit: e['profit'],
                                  createAt: e['createAt'])))
                              .toList();
                          return ListView.builder(
                            itemCount: invoices.length,
                            itemBuilder: (context, index) {
                              Map item = invoices[index].toJson();
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['id'],
                                        style: TextStyle(fontSize: 18)),
                                    Text(
                                        'Giá: ${int.parse(item['total']).toStringAsFixed(0)} đ'
                                            .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (match) => '${match[1]}.'),
                                        style: TextStyle(fontSize: 18)),
                                    Text(
                                        'Lợi nhuận: ${int.parse(item['profit']).toStringAsFixed(0)} đ'
                                            .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (match) => '${match[1]}.'),
                                        style: TextStyle(fontSize: 18))
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      })),
                )
              : Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Book')
                          .snapshots(),
                      builder: ((context, AsyncSnapshot snapshot) {
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
                          return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              Map item = books[index].toJson();
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(item['name'],
                                            style: TextStyle(fontSize: 18))),
                                    Text(
                                        '${int.parse(item['total']).toStringAsFixed(0)} đ'
                                            .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (match) => '${match[1]}.'),
                                        style: TextStyle(fontSize: 18))
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      })),
                )
        ],
      )),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/model/invoice.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử mua hàng'),
      ),
      body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Invoice')
                  .where("userId", isEqualTo:FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                  List<InvoiceModel> invoice = docs
                      .map((e) => InvoiceModel(
                          id: e.id,
                          invoice: e['invoice'],
                          userId: e['userId'],
                          total: e['total'],
                          profit: e['profit'],
                          createAt: e['createAt']))
                      .toList();

                  return ListView.builder(itemCount: invoice.length,
                    itemBuilder: (context, index) {
                    Map item = invoice[index].toJson();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Mã đơn hàng: ${item['id']}'),
                          Text('Ngày mua: ${item['createAt']}'),
                        Text('Tổng tiền: ${int.parse(item['total']).toStringAsFixed(0)} đ'
                                      .replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (match) => '${match[1]}.'),)],
                      ),
                    );
                  });
                }
                return Text('Bạn chưa mua hàng');
              })),
    );
  }
}

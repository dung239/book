import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/bookBloc.dart';
import 'package:store/src/model/book.dart';

class InfoBook extends StatefulWidget {
  final BookModel item;

  const InfoBook({super.key, required this.item});

  @override
  State<InfoBook> createState() => _InfoBookState();
}

class _InfoBookState extends State<InfoBook> {
  //  BookModel item;
  final bloc = BookBloc();
  bool _visibility = false;
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin sách'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.item.image),
                Text(
                  'Tên: ${widget.item.name}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Tác giả: ${widget.item.author}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Nội dung: ${widget.item.content}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Giá nhập: ${int.parse(widget.item.importPrice).toStringAsFixed(0)}'
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.'),
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Giá bán: ${int.parse(widget.item.price).toStringAsFixed(0)}'
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.'),
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Số lượng: ${widget.item.amount}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Tổng tiền đã nhập: ${int.parse(widget.item.total).toStringAsFixed(0)}'
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.'),
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _visibility = true;
                          });
                        },
                        child: Text('Thêm số lượng')),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bloc.valueIds!(widget.item.id);
                            });
                            bloc.deleteBook();
                          },
                          child: Text('Xóa sách')),
                    )
                  ],
                ),
                Visibility(
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    visible: _visibility,
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            _amount = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Số lượng',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              setState(() {
                                _visibility = false;
                              });
                              final int amount1 = int.parse(_amount);
                              final int amount2 = int.parse(widget.item.amount);
                              final int total = int.parse(widget.item.total);
                              final int imPrice =
                                  int.parse(widget.item.importPrice);
                              final int amountNews = amount1 + amount2;
                              final int totals = total + (imPrice * amount1);
                              FirebaseFirestore.instance
                                  .collection('Book')
                                  .doc(widget.item.id)
                                  .update({
                                'id': widget.item.id,
                                'name': widget.item.name,
                                'author': widget.item.author,
                                'category': widget.item.category,
                                'content': widget.item.content,
                                'createAt': widget.item.createAt,
                                'image': widget.item.image,
                                'importPrice': widget.item.importPrice,
                                'price': widget.item.price,
                                'total': totals.toString(),
                                'amount': amountNews.toString(),
                              });
                            }),
                            child: Text('Cập nhật'))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

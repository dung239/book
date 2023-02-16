import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/bookBloc.dart';
import 'package:store/src/bloc/cartBloc.dart';
import 'package:store/src/model/book.dart';

class BookInfo extends StatefulWidget {
  final BookModel item;

  const BookInfo({super.key, required this.item});

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {

  final blocCart = CartBloc();
  int _amount = 1;

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
                  'Giá: ${int.parse(widget.item.price).toStringAsFixed(0)}đ'
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.'),
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Số lượng: ${widget.item.amount}',
                  style: TextStyle(fontSize: 20),
                ),
                StreamBuilder<Object>(
                    stream: blocCart.amount,
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          IconButton(
                              onPressed: (() {
                                blocCart.removeItem();
                              }),
                              icon: Icon(Icons.remove)),
                          SizedBox(
                            width: 25,
                            child: Text(
                              blocCart.valueAmounts == 'null'
                                  ? '1'
                                  : blocCart.valueAmounts,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          IconButton(
                              onPressed: (() {
                                blocCart.addItem(int.parse(widget.item.amount));
                              }),
                              icon: Icon(Icons.add)),
                          Expanded(
                              child: ElevatedButton(
                            child: Text('Thêm vào giỏ hàng'),
                            onPressed: (() {
                              blocCart.addToCart(widget.item);
                            }),
                          ))
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

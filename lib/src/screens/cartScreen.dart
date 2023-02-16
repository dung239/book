import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/bloc/cartBloc.dart';
import 'package:store/src/model/book.dart';
import 'package:store/src/model/cart.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final blocCart = CartBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Giỏ hàng')),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: StreamBuilder(
                      stream: blocCart.cartStream,
                      initialData: blocCart.getCart(),
                      builder: (context, snapshot) {
                        if (blocCart.getCart().length > 0) {
                          return ListView.builder(
                            itemCount: blocCart.getCart().length,
                            itemBuilder: (context, index) {
                              Map item =
                                  blocCart.getCart().elementAt(index).toJson();
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Image.network(
                                      item['image'],
                                      width: 100,
                                      height: 100,
                                    ),
                                    Container(
                                      width: 210,
                                      child: Column(
                                        verticalDirection:
                                            VerticalDirection.down,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item['name'],
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.start),
                                          Text('Số lượng: ${item['quanlity']}',
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.start),
                                          Text(
                                              'Giá: ${int.parse(item['price']).toStringAsFixed(0)} đ'
                                                  .replaceAllMapped(
                                                      RegExp(
                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                      (match) =>
                                                          '${match[1]}.'),
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.start),
                                          Text(
                                              'Thành tiền: ${int.parse(item['price']) * int.parse(item['quanlity'])} đ'
                                                  .replaceAllMapped(
                                                      RegExp(
                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                      (match) =>
                                                          '${match[1]}.'),
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.start)
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          blocCart.removeFromCart(blocCart
                                              .getCart()
                                              .elementAt(index));
                                          setState(() {
                                            blocCart.getCart();
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                              );
                            },
                          );
                        }

                        return Container(
                          child: Text('Chưa có sản phẩm nào'),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tổng tiền: ${tinhTien()} đ'.replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (match) => '${match[1]}.'),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (() {
                          blocCart.addInvoice();
                          setState(() {
                            blocCart.getCart();
                          });
                        }),
                        child: Text('Lập hóa đơn'))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  tinhTien() {
    var sum = 0;
    blocCart.getCart().forEach((element) {
      var a = int.parse(element.quanlity) * int.parse(element.price);
      sum += a;
    });
    return sum;
  }
}

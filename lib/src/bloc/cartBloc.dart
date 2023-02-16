import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/src/model/book.dart';
import 'package:store/src/model/cart.dart';
import 'package:store/src/model/invoice.dart';
import 'package:store/src/repository/CartService.dart';

class CartBloc {
  int abc = 1;
  late BehaviorSubject<String> _amount;
  late BehaviorSubject<Map> _itemCart;
  final cartStreamController = StreamController.broadcast();
  final _id = FirebaseFirestore.instance.collection('Invoice').doc().id;

  Stream<String> get amount => _amount.stream;
  Stream get cartStream => cartStreamController.stream;

  Function(String) get valueAmount => _amount.sink.add;

  String get valueAmounts => _amount.value;

  CartBloc({abc}) {
    _amount = new BehaviorSubject<String>.seeded(abc.toString());
  }

  void dispose() {
    _amount.close();
  }

  void addToCart(BookModel item) {
    CartService.addToCart(item, _amount.value.toString());
    cartStreamController.sink.add(
      CartService.getCart(),
    );
  }

  void removeFromCart(CartModel item) {
    CartService.removeFromCart(item);
    cartStreamController.sink.add(
      CartService.getCart(),
    );
  }

  List<CartModel> getCart() {
    return CartService.getCart();
  }

  addInvoice() async {
    var total = 0;
    getCart().forEach((element) {
      var a = int.parse(element.quanlity) * int.parse(element.price);
      total += a;
    });
    var profit = 0;
    getCart().forEach((element) {
      var a = (int.parse(element.quanlity) * int.parse(element.price)) -
          (int.parse(element.quanlity) * int.parse(element.importPrice));
      profit += a;
    });

    var list = getCart().map((e) => e.toJson()).toList();

    final invoice = InvoiceModel(
        id: _id,
        // invoice: getCart(),
        invoice: list,
        userId: FirebaseAuth.instance.currentUser!.uid.toString(),
        total: total.toString(),
        profit: profit.toString(),
        createAt: DateTime.now().toIso8601String());

    FirebaseFirestore.instance
        .collection('Invoice')
        .doc(_id)
        .set(invoice.toJson())
        .then((value) => getCart().clear());

    getCart().forEach((e) async => {
        await  FirebaseFirestore.instance.collection('Book').doc(e.id).update({
            'name': e.name,
            'author': e.author,
            'category': e.category,
            'content': e.content,
            'createAt': e.createAt,
            'image': e.image,
            'importPrice': e.importPrice,
            'amount': (int.parse(e.amount) - int.parse(e.quanlity)).toString(),
            'total': e.total,
            'id': e.id,
            'price': e.price
          })
        });
  }

  void removeItem() {
    if (abc == 0) {
      abc = abc;
    }
    if (abc > 0) {
      abc--;
    }
    _amount.sink.add(abc.toString());
  }

  void addItem(int max) {
    if (abc == max) {
      abc = abc;
    }
    if (abc < max) {
      abc++;
    }
    _amount.sink.add(abc.toString());
  }
}

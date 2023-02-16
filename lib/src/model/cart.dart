import 'package:store/src/model/book.dart';
import 'package:store/src/repository/CartService.dart';

class CartModel {
  final String name;
  final String author;
  final String content;
  final String category;
  final String image;
  final String price;
  final String amount;
  final String id;
  final String quanlity;
  final String importPrice;
  final String createAt;
  final String total;


  CartModel(
      {required this.name,
      required this.author,
      required this.category,
      required this.content,
      required this.image,
      required this.amount,
      required this.id,
      required this.importPrice,
      required this.total,
      required this.createAt,
      required this.quanlity,
      required this.price});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        name: json['name'],
        author: json['author'],
        category: json['category'],
        content: json['content'],
        image: json['image'],
        amount: json['amount'],
        importPrice: json['importPrice'],
        total: json['total'],
        createAt: json['createAt'],
        id: json['id'],
        quanlity: json['quanlity'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'category': category,
      'content': content,
      'image': image,
      'price': price,
      'importPrice': importPrice,
      'total': total,
      'createAt': createAt,
      'amount': amount,
      'id': id,
      'quanlity': quanlity,
    };
  }
}

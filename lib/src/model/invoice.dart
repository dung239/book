import 'package:store/src/model/cart.dart';

class InvoiceModel {
  final String id;
  final List invoice;
  final String userId;
  final String total;
  final String profit;
  final String createAt;

  InvoiceModel({
    required this.id,
    required this.invoice,
    required this.userId,
    required this.total,
    required this.profit,
    required this.createAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
        id: json['id'],
        invoice: json['invoice'],
        userId: json['userId'],
        total: json['total'],
        profit: json['profit'],
        createAt: json['createAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice': invoice,
      'userId': userId,
      'total': total,
      'profit': profit,
      'createAt': createAt
    };
  }
}

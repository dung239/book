class BookModel {
  final String name;
  final String author;
  final String content;
  final String category;
  final String image;
  final String importPrice;
  final String price;
  final String createAt;
  final String amount;
  final String total;
  final String id;

  BookModel(
      {required this.name,
      required this.author,
      required this.category,
      required this.content,
      required this.createAt,
      required this.image,
      required this.importPrice,
      required this.amount,
      required this.total,
      required this.id,
      required this.price});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        name: json['name'],
        author: json['author'],
        category: json['category'],
        content: json['content'],
        createAt: json['createAt'],
        image: json['image'],
        importPrice: json['importprice'],
        amount: json['amount'],
        total: json['total'],
        id: json['id'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'category': category,
      'content': content,
      'createAt': createAt,
      'image': image,
      'importPrice': importPrice,
      'price': price,
      'amount': amount,
      'id': id,
      'total': total
    };
  }
}

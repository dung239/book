class CategoryModel {
  final String category;
  final String categoryId;
  final String id;
  CategoryModel({
    required this.category,
    required this.categoryId,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        category: json['category'],
        id: json['id'],
         categoryId: json['categoryId']);
  }

  Map<String, dynamic> toJson() {
    return {'category': category, 
    'id': id,
    'categoryId': categoryId};
  }
}

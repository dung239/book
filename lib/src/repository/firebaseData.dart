import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/src/model/category.dart';

class FirebaseData {
  var db = FirebaseFirestore.instance;
  Future<List<CategoryModel>> getCategory() async {
    final categorys = <CategoryModel>[];
    await db
        .collection('Category')
        .get()
        .then((value) => categorys.forEach((snapshot) {
              CategoryModel.fromJson(snapshot.toJson());
            }));
    return categorys;
  }
}

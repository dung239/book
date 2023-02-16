import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name;
  final String username;
  final String phone;
  final String uid;
  final String address;
  final String id;

  UserModel(
      {required this.name,
      required this.username,
      required this.phone,
      required this.address,
      required this.id,
      required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        username: json['username'],
        phone: json['phone'],
        address: json['address'],
        id: json['id'],
        uid: json['uid']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toString(),
      'phone': phone.toString(),
      'username': username.toString(),
      'address': address.toString(),
      'id': id.toString(),
      'uid': FirebaseAuth.instance.currentUser!.uid
    };
  }
}

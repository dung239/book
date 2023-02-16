import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/src/model/user.dart';
import 'package:store/src/screens/login.dart';
import 'package:store/src/screens/register.dart';
import 'package:store/src/validator/validator.dart';

class BlocRegister {
  final _username = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _pass = BehaviorSubject<String>();
  final _id = FirebaseFirestore.instance.collection('Users').doc().id;

  void dispose() {
    _name.close();
    _pass.close();
    _pass.close();
    _username.close();
  }

  Stream<String> get username => _username.stream.transform(_validateUser);
  Stream<String> get pass => _pass.stream.transform(_validatePass);
  Stream<String> get phone => _phone.stream.transform(_validatePhone);
  Stream<String> get name => _name.stream.transform(_validateName);

  Function(String) get nameValue => _name.sink.add;
  Function(String) get phoneValue => _phone.sink.add;
  Function(String) get usernameValue => _username.sink.add;
  Function(String) get passValue => _pass.sink.add;

  final _validateUser = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      if (Validator.isValidUser(username.toString())) {
        sink.add(username.toString());
      } else {
        sink.addError("Tên tài khoản có định dạng email");
      }
    },
  );

  final _validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      sink.add(name.toString());
    },
  );

  final _validatePhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (Validator.isValidPhone(phone.toString())) {
        sink.add(phone.toString());
      } else {
        sink.addError("Nhập đúng số điện thoại");
      }
    },
  );

  final _validatePass = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validator.isValidPass(pass.toString())) {
        sink.add(pass.toString());
      } else {
        sink.addError("Mật khẩu ít nhất 6 ký tự");
      }
    },
  );

  Future register(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _username.value.toString(),
        password: _pass.value.toString(),
      );

      var user = UserModel(
          name: _name.value,
          username: _username.value,
          phone: _phone.value,
          address:'',
          id: _id,
          uid: FirebaseAuth.instance.currentUser!.uid);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_id)
          .set(user.toJson())
          .then((value) => print("Add user"))
          .catchError((error) => print("Failed to add user: $error"));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công'),
        ),
      );
      Navigator.pop(
          context, MaterialPageRoute(builder: ((context) => Login())));
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    ;
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/src/screens/admin/adminNabar.dart';
import 'package:store/src/screens/homeNabar.dart';
import 'package:store/src/validator/validator.dart';

class LoginBloc {
  final _email = BehaviorSubject<String>();
  final _pass = BehaviorSubject<String>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose() {
    _email.close();
    _pass.close();
  }

  Stream<String> get email => _email.stream.transform(_validateEmail);
  Stream<String> get pass => _pass.stream.transform(_validatePass);

  Function(String) get valueEmail => _email.sink.add;
  Function(String) get valuePass => _pass.sink.add;

  final _validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (Validator.isValidUser(email.toString())) {
        sink.add(email.toString());
      } else {
        sink.addError("Nhập đúng định dạng email");
      }
    },
  );

  final _validatePass = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validator.isValidUser(pass.toString())) {
        sink.add(pass.toString());
      } else {
        sink.addError("Mật khẩu ít nhất 6 ký tự");
      }
    },
  );

  Future login(BuildContext context) async {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(),
          password: _pass.value.trim(),
        );

        if (FirebaseAuth.instance.currentUser!.uid.toString() ==
            '9rAtccWUgfZUB8C4fRPp0X9VSyo2'.toString()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } catch (e) {
        print(e.toString());
      }

  }
}

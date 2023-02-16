// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/src/bloc/register_bloc.dart';
import 'package:store/src/screens/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  BlocRegister blocRegister = BlocRegister();

  

  @override
  dispose() {
    blocRegister.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: StreamBuilder(
                stream: blocRegister.name,
                builder: (context, snapshot) {
                  return TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) => blocRegister.nameValue(value),
                      decoration: InputDecoration(
                          labelText: "Họ Tên",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))));
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: StreamBuilder(
                  stream: blocRegister.phone,
                  builder: (context, snapshot) {
                    return TextField(
                        keyboardType: TextInputType.number,
                      onChanged: (value) => blocRegister.phoneValue(value),
                        decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            labelText: "Số điện thoại",
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: StreamBuilder(
                  stream: blocRegister.username,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: (value) => blocRegister.usernameValue(value),
                        decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            labelText: "Tên tài khoản",
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: StreamBuilder(
                  stream: blocRegister.pass,
                  builder: (context, snapshot) {
                    return TextField(
                      autocorrect: true,
                      onChanged: (value) => blocRegister.passValue(value),
                      decoration: InputDecoration(
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          labelText: "Mật khẩu",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                      obscureText: true,
                    );
                  }),
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => blocRegister.register(
                      context),
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)))),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: InkWell(
                child: Text('Đã có tài khoản? Trở về đăng nhập'),
                onTap: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (builder) => Login()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

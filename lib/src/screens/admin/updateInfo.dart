import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:store/src/model/user.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({super.key});

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  String _name = '';
  bool _visible = false;
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cập nhật thông tin')),
      body: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where("uid",
                        isEqualTo:
                            FirebaseAuth.instance.currentUser!.uid.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(' ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> doc = querySnapshot.docs;

                    querySnapshot;

                    DocumentReference docref =
                        FirebaseFirestore.instance.collection('Users').doc();
                    String docId = docref.id;


                    List<UserModel> users = doc
                        .map((e) => UserModel(
                            id: e['id'],
                            name: e['name'],
                            username: e['username'],
                            phone: e['phone'],
                            address: e['address'],
                            uid: e['uid']))
                        .toList();



                    Map item = users[0].toJson();

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tên: ${item['name']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tên người dùng: ${item['username']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Số điện thoại: ${item['phone']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Địa chỉ: ${item['address']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _visible = true;
                                });
                              },
                              child: Text('Thêm địa chỉ')),
                          Visibility(
                              maintainAnimation: true,
                              maintainInteractivity: true,
                              maintainState: true,
                              maintainSize: true,
                              visible: _visible,
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      _address = value;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        labelText: 'Địa chỉ'),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _visible = false;
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(item['id'])
                                              .update({
                                            'id': item['id'],
                                            'name': item['name'],
                                            'username': item['username'],
                                            'phone': item['phone'],
                                            'address': _address.toString(),
                                            'uid': item['uid'],
                                          });
                                        });
                                      },
                                      child: Text('Cập nhật'))
                                ],
                              )),
                        ]);
                  }

                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ))),
    );
  }
}

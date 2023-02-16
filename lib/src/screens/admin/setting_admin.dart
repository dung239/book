import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/src/screens/admin/add_book.dart';
import 'package:store/src/screens/admin/add_category.dart';
import 'package:store/src/screens/admin/updateInfo.dart';
import 'package:store/src/screens/login.dart';

class SettingAdmin extends StatefulWidget {
  const SettingAdmin({super.key});

  @override
  State<SettingAdmin> createState() => _SettingAdminState();
}

class _SettingAdminState extends State<SettingAdmin> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AddCategory())));
                },
                child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Thêm thể loại',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ))),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AddBook())));
                },
                child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Thêm sách',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ))),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => UpdateInfo())));
                },
                child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Cập nhật thông tin',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ))),
            InkWell(
                onTap: _signOut,
                child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Login())));
  }
}

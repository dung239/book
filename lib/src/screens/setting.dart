import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/src/screens/admin/updateInfo.dart';
import 'package:store/src/screens/invoice.dart';
import 'package:store/src/screens/login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
       child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Invoice())));
                },
                child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Lịch sử đặt hàng',
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
    await _auth.signOut().then((value) =>
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  }
}

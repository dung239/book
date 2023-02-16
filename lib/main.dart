import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/src/myApp.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

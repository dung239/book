import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/src/screens/admin/adminNabar.dart';
import 'package:store/src/screens/homeNabar.dart';
import 'package:store/src/screens/login.dart';
import 'package:store/src/screens/register.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser;
  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Login(),
      );
    } else {
      if (user!.uid.toString() == '9rAtccWUgfZUB8C4fRPp0X9VSyo2'.toString()) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: HomeAdmin(),
        );
      } else {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: Home(),
        );
      }
    }
  }
}

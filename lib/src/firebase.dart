import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void firebase_option() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAwlBkabYdWu80HSdBAhSiswmbBJcEQwb8",
          appId: "1:946772464462:web:1cf993f420d536a3ff041f",
          messagingSenderId: "946772464462",
          projectId: "food-app-5fd8e"));
}


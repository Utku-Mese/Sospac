import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import '../controllers/auth_controller.dart';

//COLORS
/* const primaryColor = Color(0xFFA826C9);
const secondaryColor = Color(0xFFEEC800); */
Color primaryColor = Color(0xFFB388FF);
const secondaryColor = Color(0xFFFFC107);

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLERS
var authController = AuthController.instance;

// FUNCTIONS
int daysBetween(DateTime from) {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day)
      .difference(DateTime(from.year, from.month, from.day))
      .inDays;
}

Future<void> share(String title, String text, String url) async {
  await FlutterShare.share(
    title: title,
    text: text,
    linkUrl: url,
  );
}

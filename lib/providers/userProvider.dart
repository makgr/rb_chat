import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String userName = "username";
  String userEmail = "useremail";
  String userId = "userid";
  String userCountry = "usercountry";

  // Map<String, dynamic>? userData = {};

  var authUser = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  void getUserDetails() {
    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      userCountry = dataSnapshot.data()?["country"] ?? "";

      notifyListeners();
    });
  }
}

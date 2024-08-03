import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData = {};

  var authUser = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  void getData() {
    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userData = dataSnapshot.data();
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Text(userData?["name"] ?? ""),
          Text(userData?["email"] ?? ""),
          Text(userData?["country"] ?? ""),
        ],
      ),
    );
  }
}

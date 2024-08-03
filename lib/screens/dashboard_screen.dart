import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rb_chat/screens/profile_screen.dart';
import 'package:rb_chat/screens/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> chatroomList = [];

  void getChatRooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatroomData in dataSnapshot.docs) {
        chatroomList.add(singleChatroomData.data());
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chatroomList.length,
        itemBuilder: (BuildContext context, int index) {
          String chatRoomName = chatroomList[index]["chatroom_name"] ?? "";
          return ListTile(
            leading: CircleAvatar(
              child: Text(chatRoomName[0]),
            ),
            title: Text(chatRoomName),
            subtitle: Text(chatroomList[index]["desc"] ?? ""),
          );
        },
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text("Profile"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  }), (route) {
                    return false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

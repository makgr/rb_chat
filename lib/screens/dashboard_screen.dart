import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_chat/providers/userProvider.dart';
import 'package:rb_chat/screens/chatroom_screen.dart';
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

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomList = [];
  List<String> chatroomIds = [];

  void getChatRooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatroomData in dataSnapshot.docs) {
        chatroomList.add(singleChatroomData.data());
        chatroomIds.add(singleChatroomData.id.toString());
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
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(userProvider.userName[0]),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: chatroomList.length,
        itemBuilder: (BuildContext context, int index) {
          String chatRoomName = chatroomList[index]["chatroom_name"] ?? "";
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatroomScreen(
                  chatroomName: chatroomList[index]["chatroom_name"] ?? "",
                  chatroomId: chatroomIds[index],
                );
              }));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[900],
              child:
                  Text(chatRoomName[0], style: TextStyle(color: Colors.white)),
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
                leading: CircleAvatar(
                  child: Text(userProvider.userName[0]),
                ),
                title: Text(
                  userProvider.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userProvider.userEmail),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
                },
              ),
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

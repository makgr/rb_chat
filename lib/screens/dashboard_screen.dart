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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Column(
        children: [
          Text("Welcome"),
          Text((user?.email ?? "").toString()),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return SplashScreen();
                }), (route) {
                  return false;
                });
              },
              child: Text("Logout")),
        ],
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

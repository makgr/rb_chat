import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_chat/providers/userProvider.dart';
import 'package:rb_chat/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(userProvider.userName[0]),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              userProvider.userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(userProvider.userEmail),
            Text(userProvider.userCountry),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfileScreen();
                }));
              },
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

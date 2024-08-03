import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_chat/providers/userProvider.dart';

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
      body: Column(
        children: [
          Text(userProvider.userName),
          Text(userProvider.userEmail),
          Text(userProvider.userCountry),
        ],
      ),
    );
  }
}

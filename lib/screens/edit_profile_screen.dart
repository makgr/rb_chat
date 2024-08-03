import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_chat/providers/userProvider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var editProfileForm = GlobalKey<FormState>();

  TextEditingController nameText = TextEditingController();

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> userData = {"name": nameText.text};
    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(userData);

    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (editProfileForm.currentState!.validate()) {
                updateData();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileForm,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameText,
                  decoration: InputDecoration(
                    label: Text("Name"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

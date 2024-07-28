import 'package:flutter/material.dart';
import 'package:rb_chat/controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userForm = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required.";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  label: Text("Email"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required.";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  label: Text("Password"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (userForm.currentState!.validate()) {
                    SignupController.createAccount(
                        context: context,
                        email: email.text,
                        password: password.text);
                  }
                },
                child: Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

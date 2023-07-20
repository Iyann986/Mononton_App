import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/models/users/users.dart';

import '../movie/movie_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Users user;
  const ChangePasswordScreen({super.key, required this.user});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late Users user;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change Password'),
        backgroundColor: const Color(0xffC1232F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                controller: passwordController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Password(Min. 6 Character)");
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  prefixIcon: const Icon(
                    Icons.https_rounded,
                    color: Colors.black,
                  ),
                  hintText: "Enter Your Password",
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: const Color(0xffD7D9DD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                autofocus: false,
                controller: confirmPasswordController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (confirmPasswordController.text !=
                      passwordController.text) {
                    return "Password don't match";
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmPasswordController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.https_rounded,
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Confirm Your Password",
                  labelText: "Confirm Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: const Color(0xffD7D9DD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.id)
                      .update({
                    'password': passwordController.text,
                  });
                  FirebaseAuth.instance.currentUser!
                      .updateEmail(passwordController.text)
                      .then((value) => Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => const MovieScreen()),
                          (route) => false));
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xffC1232F),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

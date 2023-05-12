import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/users/users.dart';
import '../movie/movie_screen.dart';

class EditScreen extends StatefulWidget {
  final Users user;
  const EditScreen({super.key, required this.user});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Users user;

  // editing controller
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

  @override
  void dispose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = widget.user;
    nameEditingController.text = widget.user.name!;
    emailEditingController.text = widget.user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
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
                controller: nameEditingController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("First Name cannot be Empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid name(Min. 3 Character)");
                  }
                  return null;
                },
                onSaved: (value) {
                  nameEditingController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  prefixIcon: Icon(
                    Icons.person_rounded,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Color(0xffD7D9DD),
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
                controller: emailEditingController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Your Email");
                  }
                  // reg expression for email validation
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return ("Please Enter a valid email");
                  }
                  return null;
                },
                onSaved: (value) {
                  emailEditingController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.mail_rounded,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  filled: true,
                  fillColor: Color(0xffD7D9DD),
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
                    'name': nameEditingController.text,
                    'email': emailEditingController.text
                  });
                  FirebaseAuth.instance.currentUser!
                      .updateEmail(emailEditingController.text)
                      .then((value) => Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => MovieScreen()),
                          (route) => false));
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

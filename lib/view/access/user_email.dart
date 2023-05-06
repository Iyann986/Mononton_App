import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserEmail {
  static String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}

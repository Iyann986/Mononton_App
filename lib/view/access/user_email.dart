import 'package:firebase_auth/firebase_auth.dart';

class UserEmail {
  static String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}

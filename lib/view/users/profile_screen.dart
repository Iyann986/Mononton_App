import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mononton_app/models/users/users.dart';
import 'package:mononton_app/view/drawer_screen.dart';

import 'change_password.dart';
import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Users user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        backgroundColor: const Color(0xffC1232F),
      ),
      drawer: DrawerScreen(user: widget.user),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 100,
              child: InkWell(
                child: Image(
                  image: AssetImage('assets/images/ic_avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(
                  Icons.person_rounded,
                  color: Color(0xff717076),
                ),
                title: Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  widget.user.name!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(
                  Icons.mail_rounded,
                  color: Color(0xff717076),
                ),
                title: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  widget.user.email!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return EditScreen(user: widget.user);
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final tween = Tween(
                              begin: const Offset(0, 5), end: Offset.zero);
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xffC1232F),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ChangePasswordScreen(user: widget.user);
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final tween = Tween(
                              begin: const Offset(0, 5), end: Offset.zero);
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xffC1232F),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

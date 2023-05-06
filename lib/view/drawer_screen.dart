import 'package:firebase_auth/firebase_auth.dart';
import 'package:mononton_app/models/users/users.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/view/access/login_screen.dart';

class DrawerScreen extends StatelessWidget {
  final Users user;
  DrawerScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              // color: Color.fromARGB(214, 5, 22, 21),
              color: Color(0xff233162),
            ),
            // accountName: Text(user.name!),
            accountName: Text("User"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/ic_avatar.png',
              ),
            ),
            // accountEmail: Text(user.email!),
            accountEmail: Text("Email"),
          ),
          DrawerListTile(
            iconData: Icons.person_rounded,
            iconColor: Color(0xff464646),
            title: 'Profile',
            titleColor: Color(0xff464646),
            onTilePressed: () {
              // Navigator ke profile screen
            },
          ),
          DrawerListTile(
            iconData: Icons.movie_rounded,
            iconColor: Color(0xff464646),
            title: 'Movie',
            titleColor: Color(0xff464646),
            onTilePressed: () {
              // Navigator ke Movie Screen
            },
          ),
          DrawerListTile(
            iconData: Icons.tv_rounded,
            iconColor: Color(0xff464646),
            title: 'Watchlist',
            titleColor: Color(0xff464646),
            onTilePressed: () {
              // Navigator ke Watchlist Screen
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          DrawerListTile(
            iconData: Icons.logout_rounded,
            iconColor: Color(0xffC1232F),
            title: 'Log Out',
            titleColor: Color(0xffC1232F),
            onTilePressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              });
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final iconColor;
  final String title;
  final titleColor;
  final VoidCallback onTilePressed;

  const DrawerListTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTilePressed,
    required this.iconColor,
    required this.titleColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTilePressed,
      dense: true,
      leading: Icon(iconData),
      iconColor: iconColor,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: titleColor,
        ),
      ),
    );
  }
}

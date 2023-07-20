import 'package:firebase_auth/firebase_auth.dart';
import 'package:mononton_app/models/users/users.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/view/access/login_screen.dart';
import 'package:mononton_app/view/users/profile_screen.dart';
import 'package:mononton_app/view/watchlist/watchlist_screen.dart';

import 'movie/movie_screen.dart';

class DrawerScreen extends StatelessWidget {
  final Users user;
  const DrawerScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff233162),
            ),
            accountName: Text(user.name!),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/ic_avatar.png',
              ),
            ),
            accountEmail: Text(user.email!),
          ),
          DrawerListTile(
            iconData: Icons.person_rounded,
            iconColor: const Color(0xff464646),
            title: 'Profile',
            titleColor: const Color(0xff464646),
            onTilePressed: () {
              Navigator.pushAndRemoveUntil(
                  (context),
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            user: user,
                          )),
                  (route) => false);
            },
          ),
          DrawerListTile(
            iconData: Icons.movie_rounded,
            iconColor: const Color(0xff464646),
            title: 'Movie',
            titleColor: const Color(0xff464646),
            onTilePressed: () {
              Navigator.pushAndRemoveUntil(
                  (context),
                  MaterialPageRoute(builder: (context) => const MovieScreen()),
                  (route) => false);
            },
          ),
          DrawerListTile(
            iconData: Icons.tv_rounded,
            iconColor: const Color(0xff464646),
            title: 'Watchlist',
            titleColor: const Color(0xff464646),
            onTilePressed: () {
              Navigator.pushAndRemoveUntil(
                  (context),
                  MaterialPageRoute(
                      builder: (context) => WatchlistScreen(
                            user: user,
                          )),
                  (route) => false);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          DrawerListTile(
            iconData: Icons.logout_rounded,
            iconColor: const Color(0xffC1232F),
            title: 'Log Out',
            titleColor: const Color(0xffC1232F),
            onTilePressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
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
  // ignore: prefer_typing_uninitialized_variables
  final iconColor;
  final String title;
  // ignore: prefer_typing_uninitialized_variables
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mononton_app/themes/constant/theme_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed("/onboarding");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                  image: AssetImage('assets/images/ic_logo-removebg.png'),
                  width: 200,
                ),
              ),
              Text(
                "W  E  L  C  O  M  E        T  O",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'MONONTON',
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xffE21221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // CircularProgressIndicator(
              //   color: Color(0xffE21221),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

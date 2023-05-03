import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/view/onboarding/onboarding_screen.dart';
import 'package:mononton_app/view/splash_screen/splash_screen.dart';
import 'package:mononton_app/view/streams/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App - Mononton',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        OnboardingPage.route: (context) => const OnboardingPage(),
        LoginScreen.route: (context) => const LoginScreen(),
      },
      // home: const SplashScreen(),
    );
  }
}

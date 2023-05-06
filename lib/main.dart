import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/view/movie/category_view_model.dart';
import 'package:mononton_app/view/movie/detail_view_model.dart';
import 'package:mononton_app/view/movie/movie_screen.dart';
import 'package:mononton_app/view/movie/movie_view_model.dart';
import 'package:mononton_app/view/movie/person_view_model.dart';
import 'package:mononton_app/view/onboarding/onboarding_screen.dart';
import 'package:mononton_app/view/splash_screen/splash_screen.dart';
import 'package:mononton_app/view/access/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DetailViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => PersonViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        MovieScreen.route: (context) => const MovieScreen(),
      },
      // home: const MovieScreen(),
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:sibiru_driver/pages/home_page.dart';
import 'package:sibiru_driver/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  void initState() {
      super.initState();
      timer = Timer(const Duration(seconds: 3), () {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    Timer? timer;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Image.asset('assets/logo_portrait.png'),
      ),
    );
  }
}

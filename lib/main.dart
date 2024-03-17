import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:sibiru_driver/pages/home_page.dart';
import 'package:sibiru_driver/pages/login_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) async {
    if (valueOfPermission) {
      await Permission.locationWhenInUse.request();
    }
  });

  await Permission.notification.isDenied.then((valueOfPermission) async {
    if (valueOfPermission) {
      await Permission.notification.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiBiru Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: whiteColor,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const HomePage(),
    );
  }
}

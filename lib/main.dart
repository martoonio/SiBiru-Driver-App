import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sibiru_driver/back_service/back_services.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:sibiru_driver/pages/home_page.dart';
import 'package:sibiru_driver/pages/login_page.dart';
import 'package:sibiru_driver/pages/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Future.delayed(const Duration(seconds: 3));
  // FlutterNativeSplash.remove();

  await await Firebase.initializeApp(
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

  initializeService();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

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
        home: const SplashScreen());
  }
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:users/screens/login_Page.dart';
// //import 'package:users/screens/first_Page.dart';
// import 'package:users/screens/signup_Page.dart';
import 'package:users/splashScreen/start_splash.dart';
import 'package:users/themeProvider/theme_provider.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "#",
              appId: "#",
              messagingSenderId: "933365733465",
              projectId: "womensy-148d5"),
        )
      : await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Journey',
      // themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade200,primary: Colors.lightGreen.shade300),
      ),
      // darkTheme: Themes.darkTheme,
      // home: const UserMain(),
      home: const StartSplash(),
    );
  }
}

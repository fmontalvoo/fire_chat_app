import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:fire_chat_app/src/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Documentacion
  // https://firebase.flutter.dev/docs/overview/#initializing-flutterfire

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fire_chat_app/src/models/user.dart';

import 'package:fire_chat_app/src/blocs/user_bloc.dart';

import 'package:fire_chat_app/src/pages/home_page.dart';
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
    final userBloc = UserBloc();

    return MultiBlocProvider(
      blocs: [
        userBloc,
      ],
      // AnimatedBuilder: escucha los cambios de notifyListeners().
      child: AnimatedBuilder(
          animation: userBloc,
          builder: (context, _) {
            final user = userBloc.currentUser;

            return MaterialApp(
              title: 'Fire chat app',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: userBloc.isLoggedIn
                  ? HomePage(User(
                      id: user.uid,
                      userName: user.displayName,
                      photoUrl: user.photoURL))
                  : LoginPage(),
            );
          }),
    );
  }
}

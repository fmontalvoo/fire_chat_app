import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/user.dart';

import 'package:fire_chat_app/src/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  goHomePage(User user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage(user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: FlatButton(
            onPressed: () {
              goHomePage(null);
            },
            child: Text(
              'INICIAR SESION CON GOOGLE',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            color: Color(0xffdd4b39),
          ),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ),
      ],
    ));
  }
}

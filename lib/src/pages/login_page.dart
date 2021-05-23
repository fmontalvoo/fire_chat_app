import 'package:flutter/material.dart';

import 'package:bloc_provider/bloc_provider.dart';

import 'package:fire_chat_app/src/blocs/user_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: FlatButton(
            onPressed: MultiBlocProvider.of<UserBloc>(context).login,
            child: Text(
              'INICIAR SESION CON GOOGLE',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            color: Color(0xffdd4b39),
          ),
        ),
      ],
    ));
  }
}

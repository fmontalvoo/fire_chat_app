import 'package:flutter/material.dart';

import 'package:bloc_provider/bloc_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fire_chat_app/src/repository/auth_repository.dart';

class UserBloc extends Bloc with ChangeNotifier {
  final _authRepository = AuthRepository();
  bool _isLoggedIn = false;

  UserBloc() {
    this._isLoggedIn = (currentUser != null);
  }

  Future<User> login() async {
    final user = await _authRepository.signInWithGoogle();
    this._isLoggedIn = true;
    notifyListeners();
    return user;
  }

  void logout() {
    _authRepository.signOut();
    this._isLoggedIn = false;
    notifyListeners();
  }

  User get currentUser => _authRepository.currentUser;

  bool get isLoggedIn => this._isLoggedIn;

  @override
  void dispose() {}
}

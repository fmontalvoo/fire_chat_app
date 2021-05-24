import 'package:fire_chat_app/src/models/user.dart';

import 'package:firebase_database/firebase_database.dart';

class DataRepository {
  static final _database =
      FirebaseDatabase.instance.reference().child('fire-chat');
  static final _userDB = _database.child('user');
  static final _messageDB = _database.child('message');

  void saveUser(User user) {
    _userDB.child(user.id).set(user.toJson());
  }

  void updateUser(User user) {
    _userDB.child(user.id)
      ..update({"isOnline": user.isOnline, "lastTime": user.lastTime});
    ;
  }

  Future<User> getUser(String id) async {
    final snapshot = await _userDB.child(id).once();
    return (snapshot.value != null)
        ? (User.fromJson(snapshot.value.cast<String, dynamic>())
          ..id = snapshot.key)
        : null;
  }

  static DatabaseReference get userDB => _userDB;
  static DatabaseReference get messageDB => _messageDB;
}

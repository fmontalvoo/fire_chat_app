import 'dart:async';

import 'package:fire_chat_app/src/repository/data_repository.dart';
import 'package:flutter/material.dart';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fire_chat_app/src/models/user.dart';

import 'package:fire_chat_app/src/blocs/user_bloc.dart';

import 'package:fire_chat_app/src/widgets/user_card.dart';

import 'package:fire_chat_app/src/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  final User user;
  final UserBloc bloc;
  HomePage(this.user, this.bloc);
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<User> users = List();

  StreamSubscription<Event> onAddedSubs;
  StreamSubscription<Event> onChangeSubs;

  @override
  void initState() {
    onAddedSubs = DataRepository.userDB.onChildAdded.listen(onEntryAdded);
    onChangeSubs = DataRepository.userDB.onChildChanged.listen(onEntryChanged);
    updateOnline(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  onEntryAdded(Event event) async {
    User newUser = User.fromJson(event.snapshot.value.cast<String, dynamic>())
      ..id = event.snapshot.key;
    if (mounted)
      setState(() {
        users.add(newUser);
      });
  }

  onEntryChanged(Event event) async {
    User oldEntry = users.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });
    User newUser = User.fromJson(event.snapshot.value.cast<String, dynamic>())
      ..id = event.snapshot.key;
    if (mounted)
      setState(() {
        users[users.indexOf(oldEntry)] = newUser;
      });
  }

  void dispose() {
    onAddedSubs?.cancel();
    onChangeSubs?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.id);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: "CHATS",
                ),
                Tab(text: "ESTADOS"),
                Tab(text: "LLAMADAS"),
              ],
            ),
            backgroundColor: greenApp,
            title: Text(
              "MyChatApp",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: MultiBlocProvider.of<UserBloc>(context).logout),
            ],
          ),
          body: TabBarView(
            children: [
              listUsers(),
              new Container(
                width: 30.0,
                child: new Text('Estados'),
              ),
              new Container(
                width: 30.0,
                child: new Text('LLamadas'),
              ),
            ],
          )),
    );
  }

  listUsers() {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: users.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return buildItem(context, users[index]);
      },
    );
  }

  buildItem(BuildContext context, User peer) {
    return (peer == null || widget.user.id == peer.id)
        ? SizedBox.shrink()
        : UserCard(widget.user, peer);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        updateOnline(true);
        break;
      case AppLifecycleState.paused:
        updateOnline(false);
        break;
      default:
        break;
    }
  }

  updateOnline(bool isOnline) {
    widget.user.isOnline = isOnline;
    widget.user.lastTime = DateTime.now().microsecondsSinceEpoch.toString();
    widget.bloc.updateUser(widget.user);
  }
}

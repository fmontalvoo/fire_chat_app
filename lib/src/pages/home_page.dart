import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/user.dart';

import 'package:fire_chat_app/src/widgets/user_card.dart';

import 'package:fire_chat_app/src/utils/app_colors.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage(this.user);
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<User> users = List();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<Null> handleSignOut() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: handleSignOut),
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
      itemBuilder: (BuildContext ctxt, int index) {
        return buildItem(ctxt, users[index]);
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
        print(true);
        break;
      case AppLifecycleState.paused:
        print(false);
        break;
      default:
        break;
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fire_chat_app/src/models/user.dart';
import 'package:fire_chat_app/src/models/message.dart';

import 'package:fire_chat_app/src/pages/chat_page.dart';

import 'package:fire_chat_app/src/repository/data_repository.dart';

import 'package:fire_chat_app/src/utils/format_date.dart';

class UserCard extends StatefulWidget {
  final User peer;
  final User user;
  UserCard(this.user, this.peer);

  @override
  State<StatefulWidget> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  int count = 0;
  Message message = Message();

  StreamSubscription<Event> onAddedLastMessage;
  StreamSubscription<Event> onAddedSeen;

  @override
  void initState() {
    onAddedLastMessage = DataRepository.messageDB
        .child(getGroupId(widget.user.id, widget.peer.id))
        .limitToLast(1)
        .onChildAdded
        .listen(onEntryAdded);

    onAddedSeen = DataRepository.messageDB
        .child(getGroupId(widget.user.id, widget.peer.id))
        .orderByChild("seen")
        .equalTo(false)
        .onChildAdded
        .listen(onEntrySeen);
    super.initState();
  }

  getGroupId(String userId, String peerId) {
    return (userId.hashCode <= peerId.hashCode)
        ? '$userId-$peerId'
        : '$peerId-$userId';
  }

  onEntryAdded(Event event) async {
    Message message = Message.fromJson(event.snapshot)..id = event.snapshot.key;
    if (mounted)
      setState(() {
        this.message = message;
      });
  }

  onEntrySeen(Event event) async {
    Message message = Message.fromJson(event.snapshot)..id = event.snapshot.key;
    if (message.idFrom != widget.user.id)
      setState(() {
        count = count + 1;
      });
  }

  void dispose() {
    onAddedLastMessage?.cancel();
    onAddedSeen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      child: ListTile(
        isThreeLine: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        user: widget.user,
                        peer: widget.peer,
                      )));
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.peer.photoUrl),
        ),
        title: Text(
          "${widget.peer.userName}",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          "${this.message.content}",
          style: !(message?.seen ?? false)
              ? Theme.of(context)
                  .textTheme
                  .bodyText1
                  .apply(color: Colors.black87)
              : Theme.of(context)
                  .textTheme
                  .bodyText1
                  .apply(color: Colors.black54),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(FormatDate.getDateFormat(
                message?.timestamp ?? "1621892598484")),
            count > 0
                ? Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$count",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

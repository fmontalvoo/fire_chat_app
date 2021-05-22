import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/message.dart';

import 'package:fire_chat_app/src/widgets/content_message.dart';

import 'package:fire_chat_app/src/utils/keys.dart';
import 'package:fire_chat_app/src/utils/format_date.dart';

class ReceivedMessage extends StatelessWidget {
  final Message message;
  ReceivedMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    Keys.chatState.currentState.widget.peer.photoUrl),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${Keys.chatState.currentState.widget.peer.userName}",
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: ContentMessage(
                      message, Colors.black87, Colors.grey[200])),
            ],
          ),
          Text(
            "${FormatDate.getDateFormat(message.timestamp)}",
            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/message.dart';

import 'package:fire_chat_app/src/widgets/content_message.dart';

import 'package:fire_chat_app/src/utils/format_date.dart';

class SentMessage extends StatelessWidget {
  final Message message;

  SentMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "${FormatDate.getDateFormat(message.timestamp)}",
            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: ContentMessage(
                message,
                Colors.white,
                Colors.green,
                isSend: true,
              )),
        ],
      ),
    );
  }
}

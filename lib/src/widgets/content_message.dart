import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/message.dart';

class ContentMessage extends StatelessWidget {
  final Message message;
  final Color textColor;
  final Color contentColor;
  final bool isSend;
  ContentMessage(this.message, this.textColor, this.contentColor,
      {this.isSend = false});
  @override
  Widget build(BuildContext context) {
    return (message.type == 0)
        ? Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: isSend ? Radius.zero : Radius.circular(25),
                  topLeft: isSend ? Radius.circular(25) : Radius.zero),
            ),
            child: Text(
              "${message.content}",
              style: Theme.of(context).textTheme.body2.apply(
                    color: textColor,
                  ),
            ),
          )
        : (message.type == 1)
            ? Container(
                child: Image.network(
                message.content,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ))
            : Container(
                child: Image.asset(
                'lib/assets/images/${message.content}.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ));
  }
}

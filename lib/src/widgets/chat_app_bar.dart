import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/user.dart';

import 'package:fire_chat_app/src/utils/format_date.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final User peer;

  ChatAppBar(this.peer);

  @override
  State<StatefulWidget> createState() => ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black54),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(widget.peer.photoUrl),
              )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.peer.userName,
                style: Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.clip,
              ),
              Text(
                widget.peer.isOnline
                    ? "Online"
                    : FormatDate.getDateFormat(widget.peer.lastTime),
                style: Theme.of(context).textTheme.subtitle.apply(
                      color: Colors.green,
                    ),
              )
            ],
          ))
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}

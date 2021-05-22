import 'package:fire_chat_app/src/widgets/sent_message.dart';
import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/models/user.dart';
import 'package:fire_chat_app/src/models/message.dart';

import 'package:fire_chat_app/src/widgets/chat_app_bar.dart';

import 'package:fire_chat_app/src/utils/keys.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final User peer;

  ChatPage({Key key, this.user, this.peer}) : super(key: Keys.chatState);

  @override
  State createState() => ChatState();
}

class ChatState extends State<ChatPage> {
  String groupChatId = "";
  int _limit = 20;
  final int _limitIncrement = 20;

  bool isShowSticker = false;

  final ScrollController listScrollController = ScrollController();

  final TextEditingController textEditingController = TextEditingController();
  List<Message> messages = List();

  @override
  void initState() {
    super.initState();
    loadGroupChatId();
    listScrollController.addListener(_scrollListener);
  }

  loadGroupChatId() async {
    setState(() {
      groupChatId = (widget.user.id.hashCode <= widget.peer.id.hashCode)
          ? '${widget.user.id}-${widget.peer.id}'
          : '${widget.peer.id}-${widget.user.id}';
    });
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("llegar al fondo");
      setState(() {
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("llegar al arriba");
      setState(() {});
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      //user..chattingWith=null..updateChattingWith();
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ChatAppBar(widget.peer),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),
                ],
              ),
            ],
          ),
          onWillPop: onBackPress,
        ));
  }

  showSticker(bool isShowSticker) {
    setState(() {
      this.isShowSticker = isShowSticker;
    });
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupChatId == ''
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
            : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => SentMessage(messages[index]),
                itemCount: messages.length,
                reverse: true,
                controller: listScrollController,
              ));
  }
}

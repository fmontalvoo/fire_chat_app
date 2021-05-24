import 'dart:async';

import 'package:fire_chat_app/src/repository/data_repository.dart';
import 'package:fire_chat_app/src/widgets/received_message.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:fire_chat_app/src/models/user.dart';
import 'package:fire_chat_app/src/models/message.dart';

import 'package:fire_chat_app/src/widgets/chat_app_bar.dart';
import 'package:fire_chat_app/src/widgets/sent_message.dart';
import 'package:fire_chat_app/src/widgets/chat_textfield.dart';
import 'package:fire_chat_app/src/widgets/sticker_gridview.dart';

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
  StreamSubscription<Event> onAddedSubs;
  StreamSubscription<Event> onChangeSubs;

  @override
  void initState() {
    super.initState();
    loadGroupChatId();
    listScrollController.addListener(_scrollListener);
    onAddedSubs = getQuery().onChildAdded.listen(onEntryAdded);
    onChangeSubs = getQuery().onChildChanged.listen(onEntryChanged);
  }

  Query getQuery() {
    return DataRepository.messageDB
        .child(groupChatId)
        .orderByChild('timestamp')
        .limitToLast(_limit);
  }

  onEntryAdded(Event event) async {
    Message messageChat = await updateSeen(event.snapshot);
    setState(() {
      messages.add(messageChat);
      messages..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  onEntryChanged(Event event) async {
    if (mounted) {
      Message oldEntry = messages.singleWhere((entry) {
        return entry.id == event.snapshot.key;
      });

      Message messageChat = await updateSeen(event.snapshot);
      setState(() {
        messages[messages.indexOf(oldEntry)] = messageChat;
        messages..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    }
  }

  void dispose() {
    onAddedSubs?.cancel();
    onChangeSubs?.cancel();
    super.dispose();
  }

  updateSeen(DataSnapshot snapshot) async {
    Message messageChat = Message.fromJson(snapshot)..id = snapshot.key;
    if (messageChat.idFrom != widget.user.id) {
      messageChat.seen = true;
      await messageChat.update(groupChatId);
    }

    return messageChat;
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
                  (isShowSticker) ? StickerGridView() : SizedBox.shrink(),
                  ChatTextField()
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

  buildItem(Message messageChat) {
    print(messageChat.idFrom == widget.user.id);
    return (messageChat.idFrom == widget.user.id)
        ? SentMessage(messageChat)
        : ReceivedMessage(messageChat);
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupChatId == ''
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
            : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => buildItem(messages[index]),
                itemCount: messages.length,
                reverse: true,
                controller: listScrollController,
              ));
  }

  void onSendMessage(int type, {String content}) {
    content = (content == null) ? textEditingController.text : content;
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.isNotEmpty) {
      textEditingController.clear();
      Message(
              seen: false,
              idFrom: widget.user.id,
              idTo: widget.peer.id,
              timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
              content: content,
              type: type)
          .save(groupChatId);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}

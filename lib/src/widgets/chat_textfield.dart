import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fire_chat_app/src/utils/keys.dart';
import 'package:image_picker/image_picker.dart';

class ChatTextField extends StatefulWidget {
  ChatTextField();

  @override
  State<StatefulWidget> createState() => ChatTextFieldState();
}

class ChatTextFieldState extends State<ChatTextField> {
  ChatTextFieldState();

  String imageUrl;
  File imageFile;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(onFocusChange);
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      Keys.chatState.currentState.showSticker(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          TextFieldButton(getImage, Icons.image),
          TextFieldButton(getSticker, Icons.face),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  // Keys.chatState.currentState.onSendMessage(0);
                },
                style: TextStyle(fontSize: 15.0),
                controller: Keys.chatState.currentState.textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Escribe tu mensaje...',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          TextFieldButton(
            () => {
              // Keys.chatState.currentState.onSendMessage(0)
            },
            Icons.send,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
    );
  }

  TextFieldButton(var onPressed, IconData icon) {
    return FlatButton(
      minWidth: 10,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  Future getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) imageFile = File(pickedFile.path);

    if (imageFile != null) {
      // uploadFile();
    }
  }

  getSticker() {
    focusNode.unfocus();
    Keys.chatState.currentState
        .showSticker(!Keys.chatState.currentState.isShowSticker);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:fire_chat_app/src/utils/keys.dart';

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
    super.initState();
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
          textFieldButton(getImage, Icons.image),
          textFieldButton(getSticker, Icons.face),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  Keys.chatState.currentState.onSendMessage(0);
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
          textFieldButton(
            () => {Keys.chatState.currentState.onSendMessage(0)},
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

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = FirebaseStorage.instance.ref().child("chat/$fileName");
    var uploadTask = reference.putFile(imageFile);
    var storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        Keys.chatState.currentState.onSendMessage(1, content: imageUrl);
      });
    });
  }

  Widget textFieldButton(var onPressed, IconData icon) {
    return FlatButton(
      minWidth: 10,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  Future getImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) imageFile = File(pickedFile.path);

    if (imageFile != null) uploadFile();
  }

  getSticker() {
    focusNode.unfocus();
    Keys.chatState.currentState
        .showSticker(!Keys.chatState.currentState.isShowSticker);
  }
}

import 'package:flutter/material.dart';

// import 'package:fire_chat_app/src/utils/keys.dart';

class StickerGridView extends StatelessWidget {
  final List<String> images = [
    'CODY_1',
    'CODY_2',
    'CODY_3',
    'CODY_4',
    'CODY_5',
    'CODY_6'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
          crossAxisCount: 3,
          children: images.map((value) {
            return FlatButton(
              onPressed: () => {
                // Keys.chatState.currentState.onSendMessage(2, content: value)
              },
              child: Image.asset(
                'lib/assets/images/$value.png',
                fit: BoxFit.cover,
              ),
            );
          }).toList()),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
      ),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }
}

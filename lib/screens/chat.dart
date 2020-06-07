import 'package:flutter/material.dart';
import 'package:medicad/screens/tab_content/chat.dart';
import 'package:medicad/widgets/message.dart';

class ChatScreen extends StatelessWidget {
  final ChatModel chat;

  ChatScreen({@required this.chat });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.name),
        elevation: 0.0,
        backgroundColor: Colors.blue.shade300,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Message()
          ],
        )
      ),
    );
  }
}
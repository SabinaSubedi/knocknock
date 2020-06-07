import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicad/screens/chat.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/strings.dart';

class ChatTabContent extends StatelessWidget {
  List<ChatModel> chats = getChatList();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(chats[index].icon),
            title: Text(chats[index].name),
            subtitle: Text(chats[index].message),
            trailing: Text(chats[index].time),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatScreen(chat: chats[index] ),)
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      )
    );
  }
}


List<ChatModel> getChatList() {
  List<ChatModel> chats = List<ChatModel>();

  chats.add( ChatModel( name: "sagar", icon: Icons.account_circle, message: "Hello World", time: "25:00" ));
  chats.add( ChatModel( name: "suraj", icon: Icons.access_alarms, message: "Good Bye", time: "25:00"));
  chats.add( ChatModel( name: "suman", icon: Icons.access_time, message: "Hello World",time: "25:00"));
  chats.add( ChatModel( name: "anup", icon: Icons.accessible, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sam", icon: Icons.wrap_text, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));
  chats.add( ChatModel( name: "sujan", icon: Icons.add_call, message: "Hello World", time: "25:00"));

  return chats;
}

class ChatModel {
  String name;
  IconData icon;
  String message;
  String time;

  ChatModel({ 
    @required this.name, 
    @required this.icon,
    @required this.message, 
    @required this.time
  });
}
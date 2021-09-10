import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicad/model/knock_user.dart';
import 'package:medicad/notifiers/user.dart';
import 'package:medicad/strings.dart';
import 'package:medicad/widgets/message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final KnockUser user;

  ChatScreen({@required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.firstName),
        elevation: 0.0,
        backgroundColor: Colors.blue.shade300,
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _getChats(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var chats = snapshot.data.documents;
                  if (chats.length == 0) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('No messages'),
                        ]);
                  }

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      var dateFormat = DateFormat.yMd().add_jm();
                      Color color = Colors.orange.shade300;
                      Alignment align = Alignment.centerLeft;

                      if (chats[index]['receiver'] == widget.user.uid) {
                        color = Colors.green.shade300;
                        align = Alignment.centerRight;
                      }
                      return Message(
                          color: color,
                          align: align,
                          message: chats[index]['message'],
                          time: dateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                      chats[index]['time'])
                                  .toLocal()));
                    },
                  );
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No messages'),
                      ]);
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ]);
                }
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _messageTextController,
                    decoration: const InputDecoration(
                      hintText: Strings.ENTER_SOME_TEXT,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.ENTER_SOME_TEXT;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25.0,
                  onPressed: () {
                    String message = _messageTextController.text;
                    _sendMessage(context, widget.user, message);
                  },
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Stream<QuerySnapshot> _getChats(BuildContext context) {
    User you = Provider.of<UserNotifier>(context, listen: false).user;
    String key = widget.user.uid + you.uid;
    return Firestore.instance
        .collection('chats')
        .where('users', arrayContains: key)
        .orderBy('time')
        .snapshots();
  }

  void _sendMessage(
      BuildContext context, KnockUser other, String message) async {
    var time = new DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      User you = FirebaseAuth.instance.currentUser;
      await Firestore.instance.collection('chats').add({
        'sender': you.uid,
        'receiver': other.uid,
        'users': [you.uid + other.uid, other.uid + you.uid],
        'message': message,
        'time': time
      });
      await Firestore.instance
          .collection('recentChats')
          .document(you.uid)
          .collection('userIds')
          .document(widget.user.uid)
          .setData({'time': time});
      await Firestore.instance
          .collection('recentChats')
          .document(widget.user.uid)
          .collection('userIds')
          .document(you.uid)
          .setData({'time': time});
      _messageTextController.clear();
    } catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text('Message sending failed'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

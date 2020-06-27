import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Message extends StatelessWidget {
  final Alignment align;
  final Color color;
  final String message;
  final String time;

  Message({
    @required this.align,
    @required this.color, 
    @required this.message,
    @required this.time
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: color
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Text(
              this.message,
              textAlign: TextAlign.justify,
            ),
            Text(
              this.time,
              textAlign: TextAlign.right,
            )
            ],
          ),
        ),
      ),
    );
  }
}
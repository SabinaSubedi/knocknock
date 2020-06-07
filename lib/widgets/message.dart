import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
        child: Container(
          color: Colors.green.shade100,
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Text(
              "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
              textAlign: TextAlign.justify,
            ),
            Text(
              '22:10 PM',
              textAlign: TextAlign.right,
            )
            ],
          ),
        ),
      ),
    );
  }
}
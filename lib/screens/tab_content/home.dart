import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';

class HomeTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              height: screenSize.height * 0.5,
              color: Colors.blue.shade300,
            ),
            clipper: BackgroundClipper(),
          ),

          Container(
            child: Text( 
              'Knock@Knock',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            margin: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.03,
              horizontal: screenSize.width * 0.08
              ),
          )
         
        ],
      )
    );
  }
}
class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
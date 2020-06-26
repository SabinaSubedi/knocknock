import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/images/splash.jpg',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

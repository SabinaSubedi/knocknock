import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicad/strings.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey                  = GlobalKey<FormState>();
  final FirebaseAuth _auth        = FirebaseAuth.instance;
  final phoneNumberTextController = TextEditingController();
  final passwordTextController    = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.CREATE_AN_ACCOUNT),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Sign Up')
                ],
            ),
          ),
        ),
      ),
    );
  }
}

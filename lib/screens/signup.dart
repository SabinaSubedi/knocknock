import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicad/services/auth.dart';
import 'package:medicad/strings.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey                  = GlobalKey<FormState>();
  final FirebaseAuth _auth        = FirebaseAuth.instance;
  final emailTextController = TextEditingController(text: 'caviryd@getnada.com');
  final passwordTextController    = TextEditingController(text: '12345678');
  bool _isObsecure = true;
  bool _isSigningUp = false;

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
                  TextFormField(
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: Strings.EMAIL),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.ENTER_SOME_TEXT;
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: passwordTextController,
                          keyboardType: TextInputType.text,
                          obscureText: _isObsecure,
                          decoration:
                              const InputDecoration(hintText: Strings.PASSWORD),
                          validator: (value) {
                            if (value.isEmpty) {
                              return Strings.ENTER_SOME_TEXT;
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.eye),
                        color: _isObsecure ? Colors.black : Colors.grey,
                        onPressed: () {
                          setState(() => _isObsecure = !_isObsecure);
                        },
                      )
                    ]
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Builder(
                    builder:(context) => RaisedButton(
                      onPressed: () async {
                        setState(() => _isSigningUp = true );

                        final String email = emailTextController.text;
                        final String password = passwordTextController.text;

                        AuthService authService = new AuthService();
                       authService.signUp(email, password).then((value) {
                          final snackbar = SnackBar(
                            content: Text(Strings.REGISTER_SUCCESSFULLY)
                          );
                          Scaffold.of(context).showSnackBar(snackbar);   

                          Timer(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });        
                        }).catchError((error) {
                          final snackbar = SnackBar(
                            content: Text(error.message)
                          );
                          Scaffold.of(context).showSnackBar(snackbar);           
                        });

                        setState(() => _isSigningUp = false );
                      },
                      child: _getRegisterButton(),
                      color: Colors.blue,
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRegisterButton() {
    if(_isSigningUp) {
       return Padding(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
       return Text(
        Strings.REGISTER,
        style: TextStyle(color: Colors.white),
      );
    }
  }
}

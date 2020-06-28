import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/user.dart';
import 'package:medicad/notifiers/user_login_status.dart';
import 'package:medicad/screens/signup.dart';
import 'package:medicad/services/auth.dart';
import 'package:medicad/strings.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verificationId;
  CountryCode countryCode = CountryCode.fromCode('NP');
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController(text: '');
  final passwordTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.LOGIN),
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
                Image.asset('assets/images/app_title_color.png'),
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
                TextFormField(
                  controller: passwordTextController,
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: Strings.PASSWORD),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.ENTER_SOME_TEXT;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Builder(
                  builder:(context) => RaisedButton(
                    onPressed: () async {
                      Provider.of<UserLoginStatusNotifier>(context, listen: false).setIsLogginIn(true);
                      final String email = emailTextController.text;
                      final String password = passwordTextController.text;
                      try {
                        String message = Strings.LOGGED_IN_SUCCESSFULLY;
                        AuthService authService = new AuthService();
                        String response = await authService.signIn(email, password);
                        FirebaseUser user = await FirebaseAuth.instance.currentUser();
                        if (!  user.isEmailVerified) {
                          message = 'Please, verify your email !';
                        }

                        final snackbar = SnackBar(
                          content: Text(message)
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      } catch(error) {
                        try {
                          final snackbar = SnackBar(
                            content: Text(error.message)
                          );
                          Scaffold.of(context).showSnackBar(snackbar);
                        } catch(error){}
                      }                   
                      Provider.of<UserLoginStatusNotifier>(context, listen: false).setIsLogginIn(false);
                    },
                    child: Consumer<UserLoginStatusNotifier>(
                      builder: (context, user, child) {
                        return _getSubmitButtonChild(user.isLoggingIn);
                      },
                    ),
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignUpScreen()
                    ));
                  },
                  child: Text(Strings.CREATE_AN_ACCOUNT),
                  color: Colors.orange.shade500,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSubmitButtonChild(bool isLoggingIn) {
    if (isLoggingIn) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        Strings.SIGN_IN,
        style: TextStyle(color: Colors.white),
      );
    }
  }
}

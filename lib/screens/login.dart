import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:medicad/screens/signup.dart';
import 'package:medicad/services/auth.dart';
import 'package:medicad/strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verificationId;
  CountryCode countryCode = CountryCode.fromCode('NP');
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController(text: 'caviryd@getnada.com');
  final passwordTextController = TextEditingController(text: '12345678');
  bool _isLoggingIn = false;

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
                      setState(() => _isLoggingIn = true );
                      final String email = emailTextController.text;
                      final String password = passwordTextController.text;

                      AuthService authService = new AuthService();
                      authService.signIn(email, password).then((value) {
                        final snackbar = SnackBar(
                          content: Text(Strings.LOGGED_IN_SUCCESSFULLY)
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      }).catchError((error) {
                        final snackbar = SnackBar(
                          content: Text(error.message)
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      });
                      
                      setState(() => _isLoggingIn = false );
                    },
                    child: _getSubmitButtonChild(),
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

  Widget _getSubmitButtonChild() {
    if (_isLoggingIn) {
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

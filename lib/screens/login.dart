import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:medicad/screens/signup.dart';
import 'package:medicad/services/auth.dart';
import 'package:medicad/strings.dart';

class LoginScreen extends StatelessWidget {
  String verificationId;
  CountryCode countryCode               = CountryCode.fromCode('NP');
  final       _formKey                  = GlobalKey<FormState>();
  final       phoneNumberTextController = TextEditingController();
  
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
                  Text(
                    Strings.APP_TITLE,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  Text(
                    Strings.ORG_NAME,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic
                    ),
                  ),

                  SizedBox(
                    height: 30.0,
                  ),

                  Row(
                    children: <Widget>[                      
                      CountryCodePicker(                    
                        onChanged: (CountryCode countryCode) {
                          this.countryCode = countryCode;
                        },
                        initialSelection: 'NP',
                        favorite: ['+977','NP'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false
                      ),               
                      
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberTextController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: Strings.PHONE_NUMBER
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return Strings.ENTER_SOME_TEXT;
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  RaisedButton(
                    onPressed: () async {
                      final String phoneNumber = phoneNumberTextController.text;
                      verifyPhone(countryCode.dialCode + phoneNumber);
                    },
                    child: const Text(
                      Strings.SIGN_IN,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    color: Colors.blue
                  ),

                  SizedBox(
                    height: 50.0,
                  ),
                ]
            )
          )
        ),
      ),
    );
  }

  Future<void> verifyPhone(String phoneNumber) async {
    final PhoneVerificationCompleted phoneVerificationCompleted = (AuthCredential authCredential) {
      AuthService().signIn(authCredential);
    };

    final PhoneVerificationFailed phoneVerificationFailed = (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration( seconds: 60),
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
  }
}
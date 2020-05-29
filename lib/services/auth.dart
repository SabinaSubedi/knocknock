import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:medicad/screens/dashboard.dart';
import 'package:medicad/screens/login.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}
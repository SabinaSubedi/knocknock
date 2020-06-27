import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserNotifier with ChangeNotifier {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  void setUser(FirebaseUser user) {
    this._user = user;
    notifyListeners();
  }
}
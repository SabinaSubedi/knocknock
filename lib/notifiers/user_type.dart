import 'package:flutter/widgets.dart';

class UserTypeNotifier with ChangeNotifier {
  String _userType = 'patient';

  String get userType => _userType;

  void setUserType(String userType) {
    this._userType = userType;
    notifyListeners();
  }
}
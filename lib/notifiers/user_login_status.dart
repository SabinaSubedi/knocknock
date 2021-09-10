import 'package:flutter/widgets.dart';

class UserLoginStatusNotifier with ChangeNotifier {
  bool _isLogginIn = false;

  bool get isLoggingIn => _isLogginIn;

  void setIsLogginIn(bool isLogginIn) {
    this._isLogginIn = isLogginIn;
    notifyListeners();
  }
}

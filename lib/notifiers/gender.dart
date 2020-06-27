import 'package:flutter/widgets.dart';

class GenderNotifier with ChangeNotifier {
  String _gender = 'male';

  String get gender => _gender;

  void setGender(String gender) {
    this._gender = gender;
    notifyListeners();
  }
}
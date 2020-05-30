import 'package:flutter/widgets.dart';

class AppTitleNotifier with ChangeNotifier {
  String _title = '';

  String get title => _title;

  void setTitle(String title) {
    this._title = title;
    notifyListeners();
  }
}
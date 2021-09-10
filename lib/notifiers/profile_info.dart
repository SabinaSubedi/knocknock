import 'package:flutter/widgets.dart';
import 'package:medicad/model/knock_user.dart';

class ProfileInfoNotifier with ChangeNotifier {
  bool _isSaving = false;
  bool _isUploading = false;
  KnockUser _user;

  bool get isSaving => _isSaving;

  void setIsSaving(bool isSaving) {
    this._isSaving = isSaving;
    notifyListeners();
  }

  bool get isUploading => _isUploading;

  void setIsUploading(bool isUploading) {
    this._isUploading = isUploading;
    notifyListeners();
  }

  KnockUser get user => _user;

  void setUser(KnockUser user) {
    this._user = user;
    notifyListeners();
  }
}

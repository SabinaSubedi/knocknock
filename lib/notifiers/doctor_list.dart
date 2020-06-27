import 'package:flutter/widgets.dart';
import 'package:medicad/model/user.dart';

class DoctorListNotifier with ChangeNotifier {
  List<User> _doctorlist = List<User>();

  List<User> get doctorList => List.unmodifiable(_doctorlist );

  void setDoctorList(List<User> doctorList) {
    _doctorlist.clear();
    _doctorlist.addAll(doctorList);
    notifyListeners();
  }
}
import 'package:flutter/widgets.dart';
import 'package:medicad/model/knock_user.dart';

class DoctorListNotifier with ChangeNotifier {
  List<KnockUser> _doctorlist = [];

  List<KnockUser> get doctorList => List.unmodifiable(_doctorlist);

  void setDoctorList(List<KnockUser> doctorList) {
    _doctorlist.clear();
    _doctorlist.addAll(doctorList);
    notifyListeners();
  }
}

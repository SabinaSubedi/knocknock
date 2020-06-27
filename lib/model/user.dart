
import 'package:flutter/material.dart';

class User {
  final String uid;
  final String profileImage;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String userType;
  final String doctorSpeciality;

  User({
    this.uid,
    @required this.profileImage,
    @required this.firstName,
    @required this.lastName,
    @required this.gender,
    @required this.email,
    @required this.phone,
    @required this.address,
    @required this.userType,
    @required this.doctorSpeciality,
  });
}
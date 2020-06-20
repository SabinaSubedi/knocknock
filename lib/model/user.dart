
import 'package:flutter/material.dart';

class User {
  final String profileImage;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final String userType;
  final String doctorSpeciality;

  User({
    @required this.profileImage,
    @required this.firstName,
    @required this.lastName,
    @required this.gender,
    @required this.email,
    @required this.address,
    @required this.userType,
    @required this.doctorSpeciality

  });
}
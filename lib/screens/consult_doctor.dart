import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/doctor_list.dart';
import 'package:medicad/notifiers/music_list.dart';
import 'package:medicad/screens/chat.dart';
import 'package:medicad/strings.dart';
import 'package:provider/provider.dart';

class ConsultDoctorScreen extends StatefulWidget {
  @override
  _ConsultDoctorState createState() => _ConsultDoctorState();
}

class _ConsultDoctorState extends State<ConsultDoctorScreen> {
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.CONSULT_DOCTOR),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Consumer<DoctorListNotifier>(
          builder: (context, doctorList, child) {
            if ( doctorList == null) {
              return CircularProgressIndicator();
            }

            if ( 0 == doctorList.doctorList.length) {
              return Center(
                child: CircularProgressIndicator()
              );
            }

            var doctors = doctorList.doctorList;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                String fullname = doctors[index].firstName + ' ' + doctors[index].lastName;
                fullname = fullname.trim().isEmpty ? 'Doctor' : fullname.trim();

                String speciality = doctors[index].doctorSpeciality;
                speciality = speciality.trim().isEmpty ? 'Not Specified' : speciality.trim();
                speciality = speciality.substring(0,1).toUpperCase() + speciality.substring(1);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: doctors[index].profileImage.isEmpty ? AssetImage('assets/images/user-silhouette.png') : NetworkImage(doctors[index].profileImage),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(doctors[index].firstName),
                  subtitle: Text(speciality),
                  trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => _displayDoctorInfo(doctors[index])
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChatScreen(user: doctors[index]),
                    ));
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _displayDoctorInfo(User doctor) {
    String fullname = doctor.firstName + ' ' + doctor.lastName;
    fullname = fullname.trim().isEmpty ? 'Doctor' : fullname.trim();

    String speciality = doctor.doctorSpeciality;
    speciality = speciality.trim().isEmpty ? 'Not Specified' : speciality.trim();
    speciality = speciality.substring(0,1).toUpperCase() + speciality.substring(1);

    String email = doctor.email;
    email = email.trim().isEmpty ? 'Not Specified' : email.trim();

    String address = doctor.address;
    address = address.trim().isEmpty ? 'Not Specified' : address.trim();

    String phone = doctor.phone;
    phone = phone.trim().isEmpty ? 'Not Specified' : phone.trim();

    String gender = doctor.gender;
    gender = gender.trim().isEmpty ? 'Not Specified' : gender.trim();
    gender = gender.substring(0,1).toUpperCase() + gender.substring(1);

    showModalBottomSheet(context: context, builder: (context) {
    final screenSize = MediaQuery.of(context).size;

      return Container(
        height: screenSize.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: CircleAvatar(
                  backgroundImage: doctor.profileImage.isEmpty ? AssetImage('assets/images/user-silhouette.png') : NetworkImage(doctor.profileImage),
                  backgroundColor: Colors.transparent,
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(fullname),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.genderless),
                title: Text(gender),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.stethoscope),
                title: Text(speciality),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.mailBulk),
                title: Text(email)
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.phone),
                title: Text(phone),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.addressCard),
                title: Text(address),
              )
            ],
          ),
        ),
      );
    });
  }
}
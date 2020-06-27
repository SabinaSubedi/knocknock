import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/user.dart';
import 'package:provider/provider.dart';
import 'package:medicad/screens/chat.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/strings.dart';

class ChatTabContent extends StatefulWidget {
  @override
  _ChatTabContentState createState() => _ChatTabContentState();
}

class _ChatTabContentState extends State<ChatTabContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _getChats(context),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            SnackBar snackBar = SnackBar(
              content: Text('Something went wrong. Please, try again'),
            );
            Scaffold.of(context).showSnackBar(snackBar);
            return Center( 
              child: Text('No Messages')
            );
          } else if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                String senderId = snapshot.data.documents[index].documentID;
                return FutureBuilder(
                  future: Firestore.instance.collection('users').document(senderId).get(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      var data = snapshot.data.data;
                      User doctor = User(
                        firstName: data['firstName'],
                        lastName: data['lastName'],
                        address: data['address'],
                        doctorSpeciality: data['doctorSpeciality'],
                        email: data['email'],
                        gender: data['gender'],
                        phone: data['phone'],
                        profileImage: data['profileImage'] ?? '',
                        userType: data['userType'],
                        uid: senderId
                      );

                      String fullname = doctor.firstName + ' ' + doctor.lastName;
                      fullname = fullname.trim().isEmpty ? 'Doctor' : fullname.trim();

                      String speciality = doctor.doctorSpeciality;
                      speciality = speciality.trim().isEmpty ? 'Not Specified' : speciality.trim();
                      speciality = speciality.substring(0,1).toUpperCase() + speciality.substring(1);
                      return ListTile(
                         leading: CircleAvatar(
                          backgroundImage: doctor.profileImage.isEmpty ? AssetImage('assets/images/user-silhouette.png') : NetworkImage(doctor.profileImage),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(fullname),
                        subtitle: Text(speciality),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () => _displayDoctorInfo(doctor)
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChatScreen(user: doctor),
                          ));
                        }
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  }
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          } else {
            return Center( 
              child: CircularProgressIndicator()
            );
          }
        }
      )
    );
  }

  Stream<QuerySnapshot> _getChats(context) {
    FirebaseUser user = Provider.of<UserNotifier>(context, listen: false).user;
    return Firestore.instance.collection('recentChats').document(user.uid).collection('userIds').orderBy('time').snapshots();
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
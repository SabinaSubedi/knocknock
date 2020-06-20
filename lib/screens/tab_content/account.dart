import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as SImage;
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/profile_info.dart';
import 'package:medicad/strings.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AccountTabContent extends StatefulWidget {
  @override
  _AccountTabContentState createState() => _AccountTabContentState();
}

class _AccountTabContentState extends State<AccountTabContent> {
  final StorageReference storageReference = FirebaseStorage().ref();
  final _formKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController(text: '');
  final _lastNameTextController = TextEditingController(text: '');
  final _emailTextController = TextEditingController(text: '');
  final _addressTextController = TextEditingController(text: '');
  final _doctorSpecialityController = TextEditingController(text: '');
  String _gender = 'male';
  String _userType = 'patient';

  @override
  Widget build(BuildContext context) {    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 50.0
      ),
      child: Form(
        key: _formKey,
        child: Center(
          child: Selector<ProfileInfoNotifier, User>(
            selector: (context, data) => data.user,
            builder: (context, user, child ) {
              if ( null == user ) {
                return CircularProgressIndicator();
              }
              
              _firstNameTextController.text = user.firstName ?? '';
              _lastNameTextController.text = user.lastName ?? '';
              _emailTextController.text = user.email ?? '';
              _addressTextController.text = user.address ?? '';
              _doctorSpecialityController.text = user.doctorSpeciality ?? '';
              _gender = user.gender ?? 'male';
              _userType = user.userType ?? 'patient';

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Selector<ProfileInfoNotifier, String>(
                        selector: (context, data) => data.user.profileImage,
                        builder: (context, profileImage, child ) {
                        return CircleAvatar(
                          backgroundImage: null == profileImage ? AssetImage('assets/images/user-silhouette.png') : NetworkImage(profileImage),          
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                        );
                      }),
                      onTap: _getFile,
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    Selector<ProfileInfoNotifier, bool>(
                    selector: (context, data) => data.isUploading,
                    builder: (context, isUploading, child) {
                        return Container(
                          child: isUploading ? Theme(
                            data: Theme.of(context).copyWith(accentColor: Colors.green),
                            child: CircularProgressIndicator(),
                          ) : SizedBox( height: 0.0,),
                        );
                    }
                    ),

                    // First name.
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _firstNameTextController,
                      decoration: const InputDecoration(
                        hintText: Strings.FIRST_NAME
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.ENTER_SOME_TEXT;
                        }
                        return null;
                      },
                    ),
                  

                    // Last name.
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _lastNameTextController,
                      decoration: const InputDecoration(
                        hintText: Strings.LAST_NAME
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.ENTER_SOME_TEXT;
                        }
                        return null;
                      },
                    ),

                    // Genders
                    Row(
                      children: _getGenders(),
                    ),

                    // Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        hintText: Strings.EMAIL
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.ENTER_SOME_TEXT;
                        }
                        return null;
                      },
                    ),

                    // Address
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _addressTextController,
                      decoration: const InputDecoration(
                        hintText: 'Address'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.ENTER_SOME_TEXT;
                        }
                        return null;
                      },
                    ),

                    // User types
                    Row(
                      children: _getUserTypes(),
                    ),

                    // Doctor speciality.
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _doctorSpecialityController,
                      decoration: const InputDecoration(
                        hintText: 'Doctor Speciality'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.ENTER_SOME_TEXT;
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    RaisedButton(
                      onPressed: () => _saveAccountInfo(),
                      child: Selector<ProfileInfoNotifier, bool>(
                        selector: (context, data) => data.isSaving,
                        builder: (context, isSaving, child) {
                          if ( isSaving ) {
                            return  Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(accentColor: Colors.white),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return Text(
                              Strings.SAVE,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            );
                          }
                        },
                      ),
                      color: Colors.blue
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      )
    );
  }

  List<Widget> _getUserTypes() {
    List<Widget> userTypes = List();

    userTypes.add(Text('User Type: '));

    userTypes.add(Radio(value: 'patient', groupValue: _userType, onChanged: _handleUserTypeChange,));
    userTypes.add(Text('Patient'));

    userTypes.add(Radio(value: 'Doctor', groupValue: _userType, onChanged: _handleUserTypeChange));
    userTypes.add(Text('Doctor'));

    return userTypes;
  }

  void _handleUserTypeChange(userType) {
    setState(() => _userType = userType );
  }

  List<Widget> _getGenders() {
    List<Widget> genders = List();

    genders.add(Radio(value: 'male', groupValue: _gender, onChanged: _handleGenderChange,));
    genders.add(Text('Male'));

    genders.add(Radio(value: 'female', groupValue: _gender, onChanged: _handleGenderChange));
    genders.add(Text('Female'));

    genders.add(Radio(value: 'other', groupValue: _gender, onChanged: _handleGenderChange));
    genders.add(Text('Other'));

    return genders;
  }

  void _handleGenderChange(gender) {
    setState(() => _gender = gender );
  }

  void _getFile() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    Uuid uuid = new Uuid();
    String uid = uuid.v4();

    var filePicker = await FilePicker.getFile();
    SImage.Image image = SImage.decodeImage( File(filePicker.path).readAsBytesSync());
    SImage.Image thumbnail = SImage.copyResize(image, width: 300);

    Provider.of<ProfileInfoNotifier>(context, listen: false).setIsUploading(true);

    if (null != firebaseUser) {
      uid = firebaseUser.uid;
    }
  
    final StorageUploadTask storageUploadTask = storageReference.child('profile').child(uid).putData(SImage.encodePng(thumbnail));
    final StreamSubscription<StorageTaskEvent> streamSubscription = storageUploadTask.events.listen((event) {
    });
    
    await storageUploadTask.onComplete;
    streamSubscription.cancel();
    String  profileImage = await storageReference.child('profile').child(uid).getDownloadURL();
    User user = Provider.of<ProfileInfoNotifier>(context, listen: false).user;
    User newUser = User(
      profileImage: profileImage,
      firstName: user.firstName,
      lastName: user.lastName,
      gender: user.gender,
      email: user.email,
      address: user.address,
      userType: user.userType,
      doctorSpeciality: user.doctorSpeciality
    );

    Provider.of<ProfileInfoNotifier>(context, listen: false).setIsUploading(false);
    Provider.of<ProfileInfoNotifier>(context, listen: false).setUser(newUser);
  }

  void _saveAccountInfo() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    Uuid uuid = new Uuid();
    String uid = uuid.v4();

    Provider.of<ProfileInfoNotifier>(context, listen: false).setIsSaving(true);

    if (null != firebaseUser) {
      uid = firebaseUser.uid;
    }

    final String firstName = _firstNameTextController.text;
    final String lastName = _lastNameTextController.text;
    final String email = _emailTextController.text;
    final String address = _addressTextController.text;
    final String doctorSpeciality = _doctorSpecialityController.text;
    
    Firestore.instance.collection('users').document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'gender' : _gender,
      'email' : email,
      'userType': _userType,
      'address': address,
      'doctorSpeciality': doctorSpeciality
    }).whenComplete((){      
      Provider.of<ProfileInfoNotifier>(context, listen: false).setIsSaving(false);
    }).then((value) {
      SnackBar snackBar = SnackBar(
        content: Text('Update successfully'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }).catchError((error) {
       SnackBar snackBar = SnackBar(
        content: Text(error.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
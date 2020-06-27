import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/profile_info.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/screens/tab_content/home.dart';
import 'package:medicad/screens/tab_content/chat.dart';
import 'package:medicad/screens/tab_content/account.dart';
import 'package:medicad/strings.dart';

class  DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final StorageReference storageReference = FirebaseStorage().ref();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController( vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

 void _handleTabSelection() {
    String title = '';
    if (! _tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          title = '';
          break;
        case 1:
          title = Strings.CHAT;
          break;
        case 2:
          title = Strings.ACCOUNT;
          _getProfileImage();
          break;
        default:
          title = '';
          break;
      }
      Provider.of<AppTitleNotifier>(context, listen: false).setTitle(title);
    }
  }

  void _getProfileImage() async {
    String profileImage;
    var info;
    FirebaseUser _firebaseUser = await FirebaseAuth.instance.currentUser();

    try {
      profileImage = await storageReference.child('profile').child(_firebaseUser.uid).getDownloadURL();
    } catch( error ) {} 
    try {
      info = await Firestore.instance.collection('users').document(_firebaseUser.uid).get();
    } catch( error ) {}

    User user;
    try {
       user = User(
        profileImage: profileImage ?? '',
        firstName: info?.data['firstName'],
        lastName: info?.data['lastName'],
        gender: info?.data['gender'],
        email: _firebaseUser?.email,
        phone: info?.data['phone'],
        address: info?.data['address'],
        userType: info?.data['userType'],
        doctorSpeciality: info?.data['doctorSpeciality'],
      );
    } catch( error ) {
       user = User(
        profileImage: '',
        firstName: '',
        lastName: '',
        gender: 'male',
        email: '',
        phone: '',
        address: '',
        userType: 'patient',
        doctorSpeciality: ''
      );
    }

    Provider.of<ProfileInfoNotifier>(context, listen: false).setUser(user);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Consumer<AppTitleNotifier>(
            builder: (context, appTitle, child) {
              return Text(appTitle.title);
            }
          ),
          backgroundColor: Colors.blue.shade300,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              HomeTabContent(),
              ChatTabContent(),
              AccountTabContent(),
            ],
          )
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.chat),
            ),
            Tab(
              icon: Icon(Icons.perm_identity),
            ),
          ],
          labelColor: Colors.yellow.shade600,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.grey,
        ),
      ),
    );
  }
}
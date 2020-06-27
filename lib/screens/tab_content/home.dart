import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medicad/model/user.dart';
import 'package:medicad/notifiers/doctor_list.dart';
import 'package:medicad/notifiers/profile_info.dart';
import 'package:medicad/notifiers/user.dart';
import 'package:medicad/screens/consult_doctor.dart';
import 'package:medicad/screens/faq_list.dart';
import 'package:medicad/screens/games.dart';
import 'package:medicad/screens/music_list.dart';
import 'package:medicad/screens/videos.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/strings.dart';

class HomeTabContent extends StatefulWidget {
  @override
  _HomeTabContentState createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        child: Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
            height: screenSize.height * 0.5,
            color: Colors.blue.shade300,
          ),
          clipper: BackgroundClipper(),
        ),

        // Application title
        Container(
          width: 150.0,
          child: Image.asset('assets/images/app_title_white.png'),
          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
        ),

        // Home items
        Container(
          height: double.infinity,
          margin: EdgeInsets.only(
              left: screenSize.width * 0.08,
              right: screenSize.width * 0.08,
              top: screenSize.height * 0.08),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 50.0,
            mainAxisSpacing: 20.0,
            children: _getHomeItems().map((HomeItem homeItem) {
              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      iconSize: 75.0,
                      icon: Image.asset(homeItem.image),
                      onPressed: () => _handleHomeItemClick(context, homeItem),
                    ),
                    Text(homeItem.title),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    ));
  }

  /// Handle the home item click.
  _handleHomeItemClick(BuildContext context, HomeItem homeItem) {
    switch (homeItem.title) {
      case Strings.MUSIC:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MusicListScreen())
        );
        break;

      case Strings.FAQS:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQListScreen())
        );
        break;

      case Strings.GAMES:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GamesScreen())
        );
        break;

      case Strings.VIDEOS:
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => VideosScreen())
        );
        break;

      case Strings.CONSULT_DOCTOR:
         _getDoctors(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultDoctorScreen())
        );
        break;
      default:
        break;
    }
  }

  void _getDoctors(BuildContext context) async {
    var documents = await Firestore.instance.collection('users').where('userType', isEqualTo: 'doctor').getDocuments();
    List<User> doctors = List();
    if ( null != documents.documents) {
      int length = documents.documents.length;
      for(int index = 0; index < length; ++index) {
        var document = documents.documents[index];

        String uid = document.documentID;
        String image;
        try {
        image = await FirebaseStorage().ref().child('profile').child(uid).getDownloadURL();
        } catch( error) {

        }        

        User user = User(
          uid: uid,
          profileImage: image ?? '',
          firstName: document.data['firstName'],
          lastName: document.data['lastName'],
          email: document.data['email'],
          address: document.data['address'],
          doctorSpeciality: document.data['doctorSpeciality'],
          gender: document.data['gender'],
          phone: document.data['phone'],
          userType: document.data['userType']
        );

        doctors.add(user);
      }
    }

    Provider.of<DoctorListNotifier>(context, listen: false).setDoctorList(doctors);
  }

  /// Get list of home items.
  List<HomeItem> _getHomeItems() {
    User user = Provider.of<ProfileInfoNotifier>(context, listen: false).user;
  
    List<HomeItem> homeItems = List<HomeItem>();
    if( user == null || user.userType == 'patient' ) {
      homeItems.add(HomeItem(
          image: 'assets/images/stethoscope.png', title: Strings.CONSULT_DOCTOR));
    }
    homeItems
        .add(HomeItem(image: 'assets/images/music.png', title: Strings.MUSIC));
    homeItems
        .add(HomeItem(image: 'assets/images/video.png', title: Strings.VIDEOS));
    homeItems
        .add(HomeItem(image: 'assets/images/games.png', title: Strings.GAMES));
    homeItems
        .add(HomeItem(image: 'assets/images/faq.png', title: Strings.FAQS));
    return homeItems;
  }
}

// HomeItem class.
class HomeItem {
  String image;
  String title;

  HomeItem({
    @required this.image,
    @required this.title,
  });
}

/// Custom background clipper.
class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

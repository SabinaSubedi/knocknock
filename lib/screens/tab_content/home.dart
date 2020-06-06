import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/strings.dart';

class HomeTabContent extends StatelessWidget {
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
            child: Text( 
              'Knock@Knock',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.08
            ),
          ),

          // Home items
          Container(
            margin: EdgeInsets.only(
              left: screenSize.width * 0.08,
              right: screenSize.width * 0.08,
              top: screenSize.height * 0.08
            ),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 50.0,
              mainAxisSpacing: 20.0,
              children: _getHomeItems().map( ( HomeItem homeItem ) {
                return Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: 75.0,
                        icon: Image.asset(
                          homeItem.image
                         ),
                        onPressed: () => _handleHomeItemClick( homeItem ),
                      ),
                      Text(homeItem.title),
                    ],
                  ),
                );
              }).toList(),
            ),
          )    
        ],
      )
    );
  }

  /// Handle the home item click.
  _handleHomeItemClick(HomeItem homeItem) {
    var a = 1;
  }

  /// Get list of home items.
  List<HomeItem> _getHomeItems() {
    List<HomeItem> homeItems = List<HomeItem>();
    homeItems.add( HomeItem(image: 'assets/images/stethoscope.png', title: Strings.CONSULT_DOCTOR));
    homeItems.add( HomeItem(image: 'assets/images/music.png', title: Strings.MUSIC));
    homeItems.add( HomeItem(image: 'assets/images/video.png', title: Strings.VIDEO));
    homeItems.add( HomeItem(image: 'assets/images/games.png', title: Strings.GAMES));
    homeItems.add( HomeItem(image: 'assets/images/faq.png', title: Strings.FAQ));
    return homeItems;
  }
}

// HomeItem class.
class HomeItem {
  String image;
  String title;

  HomeItem( {
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
    path.quadraticBezierTo(size.width/4, size.height - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
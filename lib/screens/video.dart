import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String title;
  final String path;

  VideoScreen({
    @required this.title,
    @required this.path
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _videoPlayerController;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
    _playVideo(widget.path);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 0.0
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Video
              _videoPlayerController?.value?.initialized ?? false
              ? AspectRatio(
                aspectRatio: _videoPlayerController?.value?.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_videoPlayerController),
                    VideoProgressIndicator(_videoPlayerController, allowScrubbing: true),
                  ],
                )
              ) : CircularProgressIndicator(),

              SizedBox(
                height: 25.0,
              ),

              // Video title.
              Text(
                widget.title, 
                textAlign: TextAlign.center,
                style: TextStyle( fontSize: 25.0, fontWeight: FontWeight.bold),
              ),

              // Player controls.
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color:  _getPlayPauseColor(),
                  icon: _getPlayPauseIcon(),
                  iconSize: 75.0,
                  onPressed: () => _playVideo(widget.path),
                ),
                IconButton(
                  color: Colors.red,
                  iconSize: 75.0,
                    icon: FaIcon(FontAwesomeIcons.solidStopCircle),
                  onPressed: () {
                    setState(() {
                      _videoPlayerController.pause();
                      _videoPlayerController.seekTo(Duration(seconds: 0));
                    });
                  }
                ),
              ],
            ),
            ]
          ),
        ),
      ),
    );
  }

  Color _getPlayPauseColor() {
    bool isPlaying =  _videoPlayerController?.value?.isPlaying ?? false;

    if (isPlaying) {
      return Colors.brown;
    } else {
      return Colors.green;
    }
  }

  Widget _getPlayPauseIcon() {
    bool isPlaying =  _videoPlayerController?.value?.isPlaying ?? false;

    if(isPlaying) {
      return FaIcon(FontAwesomeIcons.solidPauseCircle);
    } else {
      return FaIcon(FontAwesomeIcons.solidPlayCircle);
    }
  } 

  void _playVideo(String path) async {
    String url = await _storageReference.child(path).getDownloadURL();

    bool isPlaying =  _videoPlayerController?.value?.isPlaying ?? false;

    if ( isPlaying ) {
      _videoPlayerController.pause();
      setState(() {});
    } else {
      if ( null == _videoPlayerController ) {
        _videoPlayerController =  VideoPlayerController.network(
          url
        )..initialize().then((_){
          setState(() {});
        });
      } else {
        _videoPlayerController.play();
      }
    }
  }
}
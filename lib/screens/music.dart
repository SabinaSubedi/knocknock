import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MusicScreen extends StatefulWidget {
  final String title;
  final String path;

  MusicScreen({
    @required this.title,
    @required this.path
  });

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference = FirebaseStorage.instance.ref();
  StreamSubscription<AudioPlayerState> _audioPlayerStateSubscription;
  StreamSubscription<Duration> _audioPlayerPositionSubscription;
  Duration  _duration = Duration(seconds: 0);
  Duration _position = Duration( seconds:  0 );
  bool _mute = false;

  @override
  void initState() {
    super.initState();
    _audioPlayerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
        if (AudioPlayerState.PLAYING == state ) {
          setState( () =>  _duration = _audioPlayer.duration );
        } else if (state == AudioPlayerState.STOPPED) {
          setState( () => _position = _duration );
        }
    }, onError: (msg) {
      setState(() {
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayerPositionSubscription = _audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() => _position = position );
    });
  }

  @override
  void dispose() {
    _audioPlayerStateSubscription.cancel();
    _audioPlayerPositionSubscription.cancel();
    _audioPlayer.stop();
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
              // Music title.
              Text(
                widget.title, 
                textAlign: TextAlign.center,
                style: TextStyle( fontSize: 25.0, fontWeight: FontWeight.bold),
              ),

              Slider(
                value: _position?.inMilliseconds?.toDouble() ?? 0.0,
                min: 0.0,
                max: _duration.inMilliseconds.toDouble(),
                onChanged: (double value) {
                  _audioPlayer.seek((value / 1000).roundToDouble());
                },
              ),
              // Player controls.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    color: _audioPlayer.state == AudioPlayerState.PLAYING ? Colors.brown : Colors.green,
                    icon: _audioPlayer.state == AudioPlayerState.PLAYING ? FaIcon(FontAwesomeIcons.solidPauseCircle) : FaIcon(FontAwesomeIcons.solidPlayCircle),
                    iconSize: 75.0,
                    onPressed: () => _playAudio(widget.path),
                  ),
                  IconButton(
                    color: Colors.red,
                    icon: FaIcon(FontAwesomeIcons.solidStopCircle),
                    iconSize: 75.0,
                    onPressed: () => _audioPlayer.stop(),
                  ),
                ],
              ),

              // Mute
              IconButton(
                icon: FaIcon(FontAwesomeIcons.volumeMute),
                iconSize: 50.0,
                color: _mute ? Colors.grey : Colors.black,
                onPressed: () {
                  setState(() {
                    _mute = !_mute;
                    _audioPlayer.mute(_mute);                    
                  });
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  void _playAudio(String path) async {
    String url = await _storageReference.child(path).getDownloadURL();

    if ( _audioPlayer.state != AudioPlayerState.PLAYING ) {
      _audioPlayer.play(url);
    } else {
      _audioPlayer.pause();
      setState(() {});
    }
  }
}
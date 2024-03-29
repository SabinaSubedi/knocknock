import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:medicad/model/firebase_file.dart';
import 'package:medicad/notifiers/music_list.dart';
import 'package:medicad/screens/music.dart';
import 'package:medicad/strings.dart';
import 'package:provider/provider.dart';

class MusicListScreen extends StatefulWidget {
  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageReference storageReference = FirebaseStorage.instance.ref();
  StreamSubscription<AudioPlayerState> _audioPlayerStateSubscription;
  
  @override
  void initState() {
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((event) {
      Provider.of<MusicListNotifier>(context, listen: false).setAudioPlayerState(event);
    }, onError: (msg) {
      Provider.of<MusicListNotifier>(context, listen: false).setAudioPlayerState(AudioPlayerState.STOPPED);
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
    _audioPlayerStateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.MUSIC),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: storageReference.child('music').listAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator()
              );
            } else {
              List<FirebaseFile> files = List<FirebaseFile>();
              snapshot.data['items'].forEach((key, item) => files.add(FirebaseFile(
                name: key.replaceAll('.mp3',''),
                path: item['path']
              )));

              Provider.of<MusicListNotifier>(context, listen: false).setMusicList( files );
              
              return Selector<MusicListNotifier, List<FirebaseFile>>(
                selector: (context, musicList) => musicList.musicList,
                builder: (context, musicList, child) {
                  return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      String name = files[index].name;
                      String path = files[index].path;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(name.substring(0,1)),
                        ),
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MusicScreen(title: name, path: path)
                          ));
                        },
                        title: Text(name),
                        trailing: IconButton(
                          icon: Selector<MusicListNotifier, AudioPlayerState>(
                            selector: (context, musicList) => musicList.audioPlayerState,
                            builder: (context, audioPlayerState, child) {
                              int musicIndex = Provider.of<MusicListNotifier>(context, listen: false).currentMusicIndex;
                              return FaIcon( audioPlayerState == AudioPlayerState.PLAYING && musicIndex == index ?  FontAwesomeIcons.solidPauseCircle : FontAwesomeIcons.solidPlayCircle );
                            }
                          ),
                          onPressed: () => _playAudio(path, index ),
                        )
                      );
                    }
                  );
                }
              );
            }
          },
        )
      ),
    );
  }

  void _playAudio(String path, index ) async {
    String url = await storageReference.child(path).getDownloadURL();
    
    AudioPlayerState audioPlayerState = Provider.of<MusicListNotifier>(context, listen: false).audioPlayerState;
    Provider.of<MusicListNotifier>(context, listen: false).setCurrentMusicIndex(index);
    if ( audioPlayerState != AudioPlayerState.PLAYING ) {
      audioPlayer.stop();
      audioPlayer.play(url);
    } else {
      audioPlayer.pause();
    }
  }
}
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/widgets.dart';
import 'package:medicad/model/firebase_file.dart';

class MusicListNotifier with ChangeNotifier {
  List<FirebaseFile> _musiclist = List<FirebaseFile>();
  int _currentMusicIndex = -1;
  AudioPlayerState _audioPlayerState = AudioPlayerState.COMPLETED;

  List<FirebaseFile> get musicList => List.unmodifiable(_musiclist );

  int get currentMusicIndex => _currentMusicIndex;

  AudioPlayerState get audioPlayerState => _audioPlayerState;

  void setMusicList(List<FirebaseFile> musicList) {
    _musiclist.addAll(musicList);
    notifyListeners();
  }

  void setCurrentMusicIndex(int currentMusicIndex) {
    _currentMusicIndex = currentMusicIndex;
    notifyListeners();
  }

  void setAudioPlayerState(AudioPlayerState audioPlayerState) {
    _audioPlayerState = audioPlayerState;
    notifyListeners();
  }
}
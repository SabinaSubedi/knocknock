import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/widgets.dart';
import 'package:medicad/model/firebase_file.dart';

class VideoListNotifier with ChangeNotifier {
  List<FirebaseFile> _videolist = List<FirebaseFile>();

  List<FirebaseFile> get videoList => List.unmodifiable(_videolist );

  void setVideoList(List<FirebaseFile> videoList) {
    _videolist.clear();
    _videolist.addAll(videoList);
    notifyListeners();
  }
}
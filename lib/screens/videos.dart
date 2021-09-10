import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medicad/model/firebase_file.dart';
import 'package:medicad/notifiers/videos_list.dart';
import 'package:medicad/screens/video.dart';
import 'package:medicad/strings.dart';
import 'package:provider/provider.dart';

class VideosScreen extends StatelessWidget {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.VIDEOS),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: storageReference.child('videos').listAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<FirebaseFile> files = [];
            snapshot.data['items'].forEach((key, item) => files.add(
                FirebaseFile(
                    name: key.replaceAll('.mp4', ''), path: item['path'])));

            Provider.of<VideoListNotifier>(context, listen: false)
                .setVideoList(files);

            return Selector<VideoListNotifier, List<FirebaseFile>>(
              selector: (context, videoList) => videoList.videoList,
              builder: (context, videoList, child) {
                return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      String name = files[index].name;
                      String path = files[index].path;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(name.substring(0, 1)),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VideoScreen(title: name, path: path)));
                        },
                        title: Text(name),
                      );
                    });
              },
            );
          }
        },
      )),
    );
  }
}



import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;
  late final vid;


  @override
  Widget build(BuildContext context) {
    Widget chose_file() => IconButton(
        onPressed: () async{

          final pickedfile = await  FilePicker.platform.pickFiles(type: FileType.video);

          if (pickedfile == null) return;

          else {vid = File(pickedfile.files.single.path.toString());
            init();}
        },
        icon: Icon(Icons.add_box_outlined));

    Widget display() =>
        _controller != null && _controller!.value.isInitialized
            ? VideoPlayer(_controller!)
            : Container(
                child: Center(child: Text("no vid")),
              );
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Talentgram",
          style: TextStyle(
            fontFamily: "Inter",
          ),
          ),
          actions: [
            chose_file(),
          ],
        ),
        body: Center(
          child:_controller != null &&
          _controller!.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: display(),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            });
          },
          child: _controller != null && _controller!.value.isInitialized
          ?Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,

          )
          :Icon(

            Icons.circle,
          ),
        ),
      ),
    );
  }

  void init() {


    _controller = VideoPlayerController.file(
        vid)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }


}




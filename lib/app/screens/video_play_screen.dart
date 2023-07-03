import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  const VideoPlayScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  VideoPlayerController? controller;
  String videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(videoUrl);

    controller?.addListener(() {
      setState(() {});
    });
    controller?.setLooping(true);
    controller?.initialize().then((_) => setState(() {}));
    controller?.play();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video player'),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                if (controller!.value.isPlaying) {
                  controller?.pause();
                } else {
                  controller?.play();
                }
              },
              child: AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: VideoPlayer(controller!),
              ),
            ),
          ),
          Text(
            '${controller!.value.position}'
          ),
        ],
      ),
    );
  }
}
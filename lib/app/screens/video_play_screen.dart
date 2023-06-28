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
      'http://mooni.briskbrain.com/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBPdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ca1be0a2fa70b7b813ac49ff8348928e13f5b12c/pexels-peggy-anke-3833491-1080x1920-30fps%20(3)%20(1).mp4';

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
      body: Center(
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
    );
  }
}

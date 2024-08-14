import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false; // Track if the video is playing

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Initialize the video player
  //EXPLANATION: This method initializes the video player with the video URL provided in the widget. It sets up the video player controller, listens for changes in the video player state, and initializes the video player. Once the video player is initialized, the `_isInitialized` flag is set to true. The video is set to loop and play automatically. If there is an error initializing the video, it is caught and printed to the console.

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..addListener(() {
        if (_controller.value.isInitialized && !_isInitialized) {
          setState(() {
            _isInitialized = true;
          });
        }
      })
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.play();
        setState(() {
          _isPlaying = true; // Update state to reflect the video is playing
        });
      }).catchError((error) {
        print("Error initializing video: $error");
      });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Center(child: CircularProgressIndicator()),
        Positioned(
          bottom: 20,
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _togglePlayPause,
          ),
        ),
      ],
    );
  }
}

// Importing necessary packages for video playback
import 'package:chewie/chewie.dart'; // Provides a video player widget
import 'package:flutter/material.dart'; // Flutter's material design widgets
import 'package:video_player/video_player.dart'; // Provides a VideoPlayerController for video playback

// VideoPlayerScreen widget for displaying and playing a video
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl; // URL of the video to be played

  // Constructor to initialize VideoPlayerScreen instance with a video URL
  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() =>
      _VideoPlayerScreenState(); // Create state for VideoPlayerScreen
}

// State class for VideoPlayerScreen
class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController
      _videoPlayerController; // Controller for the video player
  late ChewieController
      _chewieController; // Controller for Chewie, a video player widget

  @override
  void initState() {
    super.initState();

    // Initialize VideoPlayerController with the provided video URL
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    // Initialize ChewieController with VideoPlayerController and playback settings
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9, // Aspect ratio of the video
      autoPlay: true, // Automatically start playing the video
      looping: true, // Loop the video when it reaches the end
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the widget's UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'), // Title of the video player screen
        backgroundColor: Colors.indigo, // Background color of the app bar
      ),
      body: Center(
        child: Chewie(
            controller:
                _chewieController), // Display the video player using Chewie
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers to release resources when the widget is disposed
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

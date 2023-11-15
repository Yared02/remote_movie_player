// Importing necessary Dart and Flutter packages
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:yared/SplashScreen.dart';
import 'package:yared/videoScreen.dart';
import 'package:yared/video_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Entry point of the application
void main() => runApp(MyApp());

// Root widget of the application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Initial screen is SplashScreen
    );
  }
}

// Widget for displaying the list of videos
class VideoScreen extends StatelessWidget {
  final String appBackgroundHexColor;

  VideoScreen({required this.appBackgroundHexColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player App'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              // Add functionality to rate the app (e.g., open a rating page)
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Add functionality to share the app URL
              _shareApp();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor(appBackgroundHexColor),
              Colors.indigo,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: VideoList(appBackgroundHexColor: appBackgroundHexColor),
      ),
    );
  }

  void _shareApp() {
    // Add logic for sharing the app
  }
}

// Helper class to convert hex color codes to Color objects
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.tryParse(hexColor, radix: 16) ?? 0xFFFFFFFF;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// Widget for displaying a list of videos fetched from a JSON API
class VideoList extends StatefulWidget {
  final String appBackgroundHexColor;

  VideoList({required this.appBackgroundHexColor});

  @override
  _VideoListState createState() => _VideoListState();
}

// State class for VideoList widget
class _VideoListState extends State<VideoList> {
  late Future<List<VideoData>> videoData;

  @override
  void initState() {
    super.initState();
    videoData = fetchVideoData();
  }

  // Fetch video data from a JSON API or local storage
  Future<List<VideoData>> fetchVideoData() async {
    try {
      final response =
          await http.get(Uri.parse('https://app.et/devtest/list.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> videos = jsonData['videos'];

        // Save the JSON data to local storage
        _saveToLocalStorage('videoData', jsonData);

        return videos.map((json) => VideoData.fromJson(json)).toList();
      } else {
        // Try to load the data from local storage if there's an error accessing the server
        final Map<String, dynamic>? localData =
            await _loadFromLocalStorage('videoData');

        if (localData != null) {
          final List<dynamic> videos = localData['videos'];

          return videos.map((json) => VideoData.fromJson(json)).toList();
        }

        throw Exception('Failed to load video data');
      }
    } catch (error) {
      // Try to load the data from local storage if there's an error
      final Map<String, dynamic>? localData =
          await _loadFromLocalStorage('videoData');

      if (localData != null) {
        final List<dynamic> videos = localData['videos'];

        return videos.map((json) => VideoData.fromJson(json)).toList();
      }

      throw Exception('Failed to load video data: $error');
    }
  }

  // Save data to local storage
  Future<void> _saveToLocalStorage(
      String key, Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(data));
  }

  // Load data from local storage
  Future<Map<String, dynamic>?> _loadFromLocalStorage(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(key);

    if (jsonString != null) {
      return json.decode(jsonString);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoData>>(
      future: videoData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: 1.0,
                child: Card(
                  elevation: 5.0,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15.0),
                    title: Text(
                      snapshot.data![index].videoTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.indigo,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data![index].videoDescription ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        snapshot.data![index].videoThumbnail,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      _navigateToVideoPlayer(
                          context, snapshot.data![index].videoUrl);
                    },
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // By default, show a loading spinner
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Navigate to the video player screen
  void _navigateToVideoPlayer(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => FadeTransition(
          opacity: animation1,
          child: VideoPlayerScreen(videoUrl: videoUrl),
        ),
        transitionDuration: Duration(milliseconds: 200),
      ),
    );
  }
}

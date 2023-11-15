// Importing necessary Dart and Flutter packages
import 'dart:async'; // Provides basic support for asynchronous programming
import 'package:flutter/material.dart'; // Flutter's material design widgets
import 'package:yared/main.dart'; // Importing main.dart where the VideoScreen is defined

// SplashScreen widget is a stateful widget for displaying a splash screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() =>
      _SplashScreenState(); // Create state for SplashScreen
}

// State class for SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer to navigate to VideoScreen after 2 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VideoScreen(appBackgroundHexColor: "#34db93"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the widget's UI
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here, e.g., an image or logo
            // Image.asset('assets/splash_logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            Text(
              'Welcome to Video App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

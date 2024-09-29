import 'package:care_connect/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CareConnectScreen extends StatefulWidget {
  @override
  _CareConnectScreenState createState() => _CareConnectScreenState();
}

class _CareConnectScreenState extends State<CareConnectScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigate to the next screen after 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // Replace with your next screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1A998E), // Updated background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync, // Use the specific symbol you mentioned
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'CareConnect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

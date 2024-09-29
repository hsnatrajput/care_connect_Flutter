import 'package:care_connect/login_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5), // Light blue background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            // Image in the center
            Center(
              child: Image.asset(
                'assets/images/startpic.png', // Replace with your actual image path
                height: 300, // Adjust size accordingly
              ),
            ),
            SizedBox(height: 30),
            // Start Button
            TextButton(
              onPressed: () {
                // Define your start button action here
                Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.transparent, // Text color
                textStyle: TextStyle(
                  fontSize: 24, // Font size for the button
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('START'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}


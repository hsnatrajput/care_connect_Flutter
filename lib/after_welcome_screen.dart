import 'package:care_connect/start_screen.dart';
import 'package:care_connect/track_progress.dart';
import 'package:care_connect/welcome_screen.dart';
import 'package:care_connect/login_screen.dart';
import 'package:flutter/material.dart';


class MedicationExperienceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6), // Light blue background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50), // Placeholder for time (if needed)
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>StartScreen()));
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/afterwelcome.png', // Replace with your image path
                    height: 250, // Adjust size according to your needs
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFD7F6F6), // Light greenish box
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Create Your Own Medication Experience',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c)=>WelcomeScreen()));
                              },
                            ),
                            Row(
                              children: [
                                Icon(Icons.circle, size: 10, color: Colors.grey),
                                SizedBox(width: 5),
                                Icon(Icons.circle, size: 10, color: Colors.black),
                                SizedBox(width: 5),
                                Icon(Icons.circle, size: 10, color: Colors.grey),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c)=>TrackProgressScreen()));
                              },
                            ),
                          ],
                        ),
                      ],

                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:care_connect/login_screen.dart';
import 'package:flutter/material.dart';

import 'Doctors/DoctorLogin.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
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
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                backgroundColor: Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child:const Text(
                'PATIENT',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>DoctorLoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                backgroundColor: Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child:Text(
                'DOCTOR',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}


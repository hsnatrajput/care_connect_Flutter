import 'package:care_connect/forget_password2.dart';
import 'package:care_connect/forget_password_screen.dart';
import 'package:care_connect/home_screen.dart';
import 'package:care_connect/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6), // Light blue background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50), // Adjust top padding
            Text(
              "WELCOME",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/login.png', // Replace with your image path
              height: 150,
            ),
            SizedBox(height: 20),
            // Username TextField
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Password TextField
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>ForgetPasswordScreen()));
                },
                child: Text(
                  'Forget password?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>DoctorAppointmentPromoScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0), backgroundColor: Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ), // Button color (teal)
              ),
              child: Text(
                'LOG IN',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // Divider with "OR"
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("OR"),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Social media icons (Facebook, Google, Twitter)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/facebook.png'), // Replace with your path
                  iconSize: 40,
                  onPressed: () {
                    // Facebook login functionality
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Image.asset('assets/images/google.png'), // Replace with your path
                  iconSize: 40,
                  onPressed: () {
                    // Google login functionality
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Image.asset('assets/images/twitter.png'), // Replace with your path
                  iconSize: 40,
                  onPressed: () {
                    // Twitter login functionality
                  },
                ),
              ],
            ),
            Spacer(),
            // Signup link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have account? "),
                GestureDetector(
                  onTap: () {
                    // Sign up functionality
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}



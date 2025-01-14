

import 'package:care_connect/forget_password_screen.dart';
import 'package:care_connect/home_screen.dart';
import 'package:care_connect/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'BottomNavigationbar.dart';
import 'DoctorSignUp.dart';
import 'appointment_detail.dart';

class DoctorLoginScreen extends StatefulWidget {
  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if the user is a doctor by fetching the user from the 'doctors' collection
      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(userCredential.user!.uid)
          .get();

      if (doctorDoc.exists) {
        // User is a doctor, navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorNavigation()),
        );
      } else {
        // User is not a doctor, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are not authorized to login as a doctor.")),
        );
        await _auth.signOut(); // Sign out the user to prevent unauthorized access
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

 /* Future<void> signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // User cancelled login
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if the user is a doctor by fetching the user from the 'doctors' collection
      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(userCredential.user!.uid)
          .get();

      if (doctorDoc.exists) {
        // User is a doctor, navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorAppointmentPromoScreen()),
        );
      } else {
        // User is not a doctor, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are not authorized to login as a doctor.")),
        );
        await _auth.signOut(); // Sign out the user to prevent unauthorized access
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6), // Light blue background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          children: [
            SizedBox(height: 50),
            Center(
              child: Text(
                "WELCOME DOCTOR",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/login.png',
              height: 150,
            ),
            SizedBox(height: 20),
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Password TextField
            TextField(
              controller: _passwordController,
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ForgetPasswordScreen()));
                },
                child: Text(
                  'Forget password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Login Button
            ElevatedButton(
              onPressed: isLoading ? null : signInWithEmailAndPassword,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                backgroundColor: Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'LOG IN',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          /*  Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("OR"),
                ),
                Expanded(
                  child: Divider(color: Colors.black),
                ),
              ],
            ),*/
            SizedBox(height: 15),
         /*   ElevatedButton.icon(
              onPressed: isLoading ? null : signInWithGoogle,
              icon: Image.asset('assets/images/google.png', height: 24),
              label: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Google', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                backgroundColor: Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),*/
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => DoctorSignUpScreen()));
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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


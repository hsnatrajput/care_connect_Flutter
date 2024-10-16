import 'package:care_connect/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? username; // Variable to store the fetched username
  String? email; // Variable to store the email

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the drawer is opened
  }

  // Method to fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Get the user's document from Firestore using their UID
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['name']; // Assuming 'name' is the field in Firestore
            email = user.email; // You can also display the email from Firebase Auth
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              username ?? 'Loading...', // Display the username or loading text
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email ?? 'example@example.com', // Display the user's email or a default value
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                username != null
                    ? username![0].toUpperCase() // First letter of the username
                    : 'U', // Default letter if username isn't loaded yet
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.teal, // Customize header color
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigate to home
              Navigator.of(context).pop();
            },
          ),

          Spacer(), // Push the logout button to the bottom of the drawer
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>StartScreen())); // Redirect to login screen
            },
          ),
        ],
      ),
    );
  }
}

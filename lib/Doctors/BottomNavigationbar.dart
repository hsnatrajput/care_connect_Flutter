import 'package:care_connect/Doctors/appointment_detail.dart';
import 'package:care_connect/Doctors/userlist.dart';
import 'package:care_connect/edit_doctor_profile.dart';
import 'package:flutter/material.dart';



class doctornavigation extends StatefulWidget {
  @override
  _doctornavigationState createState() => _doctornavigationState();
}

class _doctornavigationState extends State<doctornavigation> {
  int _selectedIndex = 0;

  // List of screens that correspond to each bottom navigation tab
  final List<Widget> _screens = [
   AppointmentDetailsScreen(),
    UserListScreen(),
    EditProfileScreen(),
  ];

  // Function to handle index changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Set the selected index based on tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen in the body
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFABD5D5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

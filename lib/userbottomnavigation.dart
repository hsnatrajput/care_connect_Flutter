import 'package:flutter/material.dart';
import 'find_doctor.dart';
import 'docotrList.dart';
import 'Records.dart';
import 'medcine.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens that correspond to each bottom navigation tab
  final List<Widget> _screens = [
    FindDoctorScreen(),   // Home Screen: Find Doctors
    DoctorListScreen(),   // Chat Screen: Doctor List or Chats
    UserRecordsScreen(),  // Records Screen: User Medical Records and Appointments
    MedicineListScreen(), // Medicine Screen: Medicine list and payment options
  ];

  // Function to handle index changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen in the body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle tab change
        type: BottomNavigationBarType.fixed, // Ensure that the color works
        backgroundColor: Color(0xFFABD5D5), // Set the background color
        selectedItemColor: Colors.black, // Color for the selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // First screen: Find Doctor
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat', // Second screen: Doctor List or Chat
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Records', // Third screen: Medical Records
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_sharp),
            label: 'Medicines', // Fourth screen: Medicine List
          ),
        ],
      ),
    );
  }
}

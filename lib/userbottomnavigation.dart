import 'package:care_connect/medcine.dart';
import 'package:flutter/material.dart';
import 'docotrList.dart';
import 'find_doctor.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens that correspond to each bottom navigation tab
  final List<Widget> _screens = [
   FindDoctorScreen(),
    DoctorListScreen(),
    MedicineListScreen(),
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
        currentIndex: _selectedIndex,
        backgroundColor:  Color(0xFFABD5D5),
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
            icon: Icon(Icons.medical_information_sharp),
            label: 'Medicines',
          ),
        ],
      ),
    );
  }
}

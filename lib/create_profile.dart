import 'package:care_connect/drayesha_screen.dart';
import 'package:care_connect/signup_screen.dart';
import 'package:flutter/material.dart';



class ProfileSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
          },
        ),
        title: Text('Create your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileOption(
              icon: Icons.person,
              label: 'Patient Profile',
              onTap: () {
               /* Navigator.push(context, MaterialPageRoute(builder: (c)=>DoctorProfileScreen()));*/
              },
            ),
            SizedBox(height: 20),
            _buildProfileOption(
              icon: Icons.medical_services,
              label: 'Doctor Profile',
              onTap: () {
                // Navigate to doctor profile creation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

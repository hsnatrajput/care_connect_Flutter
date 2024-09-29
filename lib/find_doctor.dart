import 'package:care_connect/drayesha_screen.dart';
import 'package:flutter/material.dart';



class FindDoctorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Find a Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for doctors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildCategoryCard('Cardiologist', Icons.favorite),
                      _buildCategoryCard('Neurologist', Icons.grain),
                      _buildCategoryCard('Orthopedist', Icons.accessibility),
                      _buildCategoryCard('Psychiatrist', Icons.psychology),
                      _buildCategoryCard('Pediatrician', Icons.child_care),
                      // Add more categories as needed
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Recommended Doctors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildDoctorCard(context,'Dr. Ayusha Ali', 'Cardiologist'),
                  _buildDoctorCard(context,'Dr. Mehmood Hasan', 'Cardiologist'),
                  _buildDoctorCard(context,'Dr. Shristhi Munawar', 'Psychiatrist'),
                  _buildDoctorCard(context,'Dr. Imran', 'Allergist'),
                  // Add more doctors as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context,String name, String specialty) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/doctor_placeholder.png'), // Add your doctor image asset here
        ),
        title: Text(name),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c)=>DoctorProfileScreen()));
          },
          child: Text('Book Appointment'),
        ),
      ),
    );
  }
}

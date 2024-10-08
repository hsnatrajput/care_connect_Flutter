import 'package:care_connect/time_slot.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String? imageUrl;
  final String experience;
  final int people;
  final int reviews;
  final int fee;
  final String about;

  DoctorProfileScreen({
    required this.name,
    required this.specialty,
    this.imageUrl,
    this.experience = '0 years',
    this.people = 0,
    this.reviews = 0,
    this.fee = 0,
    this.about = 'No additional information provided.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        backgroundColor: Color(0xFFABD5D5),
        title: Text('Doctor Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Add messaging functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Add calling functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : AssetImage('assets/images/doc.png') as ImageProvider,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      specialty,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBadge(experience, 'Experience'),
                _buildBadge('$people+', 'People'),
                _buildBadge('$reviews+', 'Reviews'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              about,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => TimeSlotSelectionScreen()),
                );
              },
              child: Text('Book Appointment - $fee PKR'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

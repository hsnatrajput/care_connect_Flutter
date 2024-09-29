import 'package:flutter/material.dart';



class AppointmentDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sonia Munawar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Tuesday 13 Morning 9:00am',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Age: 22',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 20),
                Text(
                  'Gender: Female',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.teal, size: 30),
                  onPressed: () {
                    // Add call functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.teal, size: 30),
                  onPressed: () {
                    // Add message functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.teal, size: 30),
                  onPressed: () {
                    // Add more options functionality
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

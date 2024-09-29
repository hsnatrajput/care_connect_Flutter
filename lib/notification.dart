import 'package:flutter/material.dart';



class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Scheduled Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildAppointmentCard('Sonia Munawar', 'Tuesday 13', '9:00 AM'),
            SizedBox(height: 20),
            Text(
              'Tomorrow',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildAppointmentCard('Sonia Munawar', 'Wednesday 14', '9:00 AM'),
            _buildAppointmentCard('Sonia Munawar', 'Monday 12', '9:00 AM'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String name, String day, String time) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('$day at $time'),
        trailing: Switch(
          value: true,
          onChanged: (bool value) {
            // Handle toggle switch
          },
          activeColor: Colors.green,
        ),
      ),
    );
  }
}

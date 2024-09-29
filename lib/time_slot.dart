import 'package:care_connect/personal_detail.dart';
import 'package:flutter/material.dart';



class TimeSlotSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Select Time Slot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDaySelector(),
            SizedBox(height: 20),
            _buildTimeSlots('Morning', ['08:00 AM', '09:00 AM', '10:00 AM']),
            SizedBox(height: 20),
            _buildTimeSlots('Noon', ['12:00 PM', '01:00 PM', '02:00 PM']),
            SizedBox(height: 20),
            _buildTimeSlots('Evening', ['04:00 PM', '05:00 PM', '06:00 PM']),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>PersonalDetailsScreen()));
              },
              child: Text('Confirm Time Slot'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDayCard('Mon', '12'),
        _buildDayCard('Tue', '13'),
        _buildDayCard('Wed', '14'),
        _buildDayCard('Thu', '15'),
        _buildDayCard('Fri', '16'),
        _buildDayCard('Sat', '17'),
      ],
    );
  }

  Widget _buildDayCard(String day, String date) {
    return Column(
      children: [
        Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(date, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildTimeSlots(String period, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(period, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: times.map((time) => _buildTimeSlotCard(time)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotCard(String time) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(time, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

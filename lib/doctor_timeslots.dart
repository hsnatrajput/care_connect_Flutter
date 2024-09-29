import 'package:flutter/material.dart';



class AppointmentSchedulingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendar(),
            SizedBox(height: 20),
            _buildTimeSlots(),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add your booking logic here
              },
              child: Text('Confirm Appointment'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      height: 200,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: 31, // Assuming the month has 31 days
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle date selection
            },
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: index == 13 ? Colors.teal : Colors.white, // Highlight the selected date
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index == 13 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTimeSlotCard('09:00 AM'),
            _buildTimeSlotCard('09:30 AM'),
            _buildTimeSlotCard('10:00 AM'),
            _buildTimeSlotCard('10:15 AM'),
            // Add more time slots as needed
          ],
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

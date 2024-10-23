import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        backgroundColor: Color(0xFFABD5D5),
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('timestamp', descending: true) // Order by timestamp
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Notifications Found'));
            }

            var notifications = snapshot.data!.docs;

            // Group notifications by day
            Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

            for (var notification in notifications) {
              var data = notification.data() as Map<String, dynamic>;
              DateTime timestamp = data['timestamp'].toDate();
              String formattedDate = _getFormattedDate(timestamp);

              if (!groupedNotifications.containsKey(formattedDate)) {
                groupedNotifications[formattedDate] = [];
              }
              groupedNotifications[formattedDate]!.add(data);
            }

            return ListView.builder(
              itemCount: groupedNotifications.keys.length,
              itemBuilder: (context, index) {
                String dateKey = groupedNotifications.keys.elementAt(index);
                List<Map<String, dynamic>> dateNotifications = groupedNotifications[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        dateKey,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...dateNotifications.map((notification) {
                      return Card(
                        child: ListTile(
                          title: Text(notification['message']),
                          subtitle: Text(_formatTime(notification['timestamp'].toDate())),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper method to format the date into a string
  String _getFormattedDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));

    if (date.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else if (date.isAfter(today) && date.isBefore(today.add(Duration(days: 7)))) {
      return 'This Week';
    } else {
      return '${date.day}/${date.month}/${date.year}'; // Show date for older notifications
    }
  }

  // Helper method to format the time to 12-hour format with AM/PM
  String _formatTime(DateTime date) {
    String hour = date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();
    String minute = date.minute.toString().padLeft(2, '0');
    String period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

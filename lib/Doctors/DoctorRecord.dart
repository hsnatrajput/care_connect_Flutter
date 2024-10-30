import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'BottomNavigationbar.dart';

class DoctorRecordScreen extends StatefulWidget {
  @override
  _DoctorRecordScreenState createState() => _DoctorRecordScreenState();
}

class _DoctorRecordScreenState extends State<DoctorRecordScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  int totalAppointments = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    if (currentUser != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('appointments')
            .where('doctorId', isEqualTo: currentUser!.uid)
            .get();

        totalAppointments = snapshot.docs.length;
        totalRevenue = snapshot.docs.fold(
          0.0,
              (sum, doc) => sum + (doc.data() as Map<String, dynamic>)['fee'] ?? 0.0,
        );

        setState(() {});
      } catch (e) {
        print("Error fetching records: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Record'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Total Appointments Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.teal.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Appointments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$totalAppointments',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Space between cards
            // Total Revenue Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.teal.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\RS ${totalRevenue.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Space for future cards
            // You can add more cards here...
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            // Implement any functionality, if needed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorNavigation(),
              ),
            );
          },
          child: Text('More Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

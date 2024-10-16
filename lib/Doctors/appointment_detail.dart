import 'package:care_connect/Doctors/userlist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chatScreen.dart';
import 'editdoctorProfile.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6),
      appBar: AppBar(
        title: Text('Appointment Details'),
        backgroundColor: Color(0xFFB8E6E6),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Appointments Found'));
          }

          // Retrieve list of appointments
          var appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use null-aware operator to handle possible null values
                      Text(
                        appointment['patientName'] ?? 'Unknown Patient',  // Default to 'Unknown Patient' if null
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        appointment['time'] ?? 'No Time Available',  // Default to 'No Time Available'
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        appointment['problemDescription'] ?? 'No Description Available',  // Default to 'No Time Available'
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Age: ${appointment['age'] ?? 'N/A'}',  // Default to 'N/A' if age is null
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Gender: ${appointment['gender'] ?? 'Unknown'}',  // Default to 'Unknown'
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        /*  IconButton(
                            icon: Icon(Icons.call, color: Colors.teal, size: 30),
                            onPressed: () {
                              // Add call functionality
                            },
                          ),*/
                          IconButton(
                            icon: Icon(Icons.message, color: Colors.teal, size: 30),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverId:appointment['patientId'] , senderId: FirebaseAuth.instance.currentUser!.uid, receiverName: appointment['patientName'],)));
                              // Add message functionality
                            },
                          ),
                   /*  *//*     IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.teal, size: 30),
                            onPressed: () {
                              // Add more options functionality
                            },*//*
                          ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

    );

  }

  Future<QuerySnapshot> _fetchAppointments() async {
    // Assuming you have authenticated the current doctor
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("No logged-in user");
    }

    String doctorId = currentUser.uid;  // The current doctor ID

    // Query Firestore for all appointments where doctorId matches the current user ID
    return await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .get();
  }
}

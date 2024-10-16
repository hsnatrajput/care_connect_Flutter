import 'package:care_connect/find_doctor.dart';
import 'package:care_connect/userbottomnavigation.dart';
import 'package:flutter/material.dart';


class DoctorAppointmentPromoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/home.png'), // Add your illustration asset here
            SizedBox(height: 20),
            Text(
              'Best Online Doctor Appointment App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
              },
              child: Text('GO'),
            ),
          ],
        ),
      ),
    );
  }
}

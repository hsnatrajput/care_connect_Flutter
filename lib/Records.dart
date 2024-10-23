import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRecordsScreen extends StatefulWidget {
  @override
  _UserRecordsScreenState createState() => _UserRecordsScreenState();
}

class _UserRecordsScreenState extends State<UserRecordsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Records"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Medicines'),
            Tab(text: 'Appointments'),
          ],
        ),
        backgroundColor: Color(0xFFB8E6E6),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicineOrders(),
          _buildAppointments(),
        ],
      ),
    );
  }

  // Fetch and display medicine orders of the current user
  Widget _buildMedicineOrders() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('medicine_orders')
          .where('userId', isEqualTo: currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Medicine Orders Found'));
        }

        var orders = snapshot.data!.docs;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index].data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(order['medicineName']),
                subtitle: Text('Price: \$${order['price']}'),
                trailing: Text(order['address']),
              ),
            );
          },
        );
      },
    );
  }

  // Fetch and display appointments of the current user
  Widget _buildAppointments() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('appointments')
          .where('patientId', isEqualTo: currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Appointments Found'));
        }

        var appointments = snapshot.data!.docs;
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            var appointment = appointments[index].data() as Map<String, dynamic>;
            return _buildAppointmentCard(appointment['doctorId'], appointment);
          },
        );
      },
    );
  }

  // Build a card for each appointment
  Widget _buildAppointmentCard(String doctorId, Map<String, dynamic> appointment) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('doctors').doc(doctorId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Loading...'),
              subtitle: Text('Loading...'),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Unknown Doctor'),
              subtitle: Text('Time: ${appointment['time'] ?? 'No Time Available'}'),
              trailing: Text('Problem: ${appointment['problemDescription'] ?? 'N/A'}'),
            ),
          );
        }

        var doctor = snapshot.data!.data() as Map<String, dynamic>;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Doctor: ${doctor['name'] ?? 'Unknown Doctor'}'),
            subtitle: Text('Time: ${appointment['time'] ?? 'No Time Available'}'),
            trailing: Text('Problem: ${appointment['problemDescription'] ?? 'N/A'}'),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'drayesha_screen.dart';

class FindDoctorScreen extends StatelessWidget {
  // Map of specialty to icons
  final Map<String, IconData> specialtyIcons = {
    'Cardiologist': Icons.favorite,
    'Neurologist': Icons.grain,
    'Orthopedist': Icons.accessibility,
    'Psychiatrist': Icons.psychology,
    'Pediatrician': Icons.child_care,
    'Allergist': Icons.filter_vintage,
    // Add more specialties with icons as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Find a Doctor'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFABD5D5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for doctors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No doctors found.'));
                  }

                  final doctors = snapshot.data!.docs;

                  // Categorize doctors based on their specialties
                  Map<String, List<DocumentSnapshot>> categorizedDoctors = {};
                  for (var doc in doctors) {
                    var specialty = doc['specialty'];
                    if (!categorizedDoctors.containsKey(specialty)) {
                      categorizedDoctors[specialty] = [];
                    }
                    categorizedDoctors[specialty]!.add(doc);
                  }

                  return ListView(
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: categorizedDoctors.keys.map((specialty) {
                          return _buildCategoryCard(context, specialty);
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Recommended Doctors',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Display doctors in a particular category
                      ...doctors.map((doc) {
                        return _buildDoctorCard(context, doc);
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracts doctor data and creates a doctor card
  // Builds a card for each doctor
  Widget _buildDoctorCard(BuildContext context, DocumentSnapshot doc) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: _getImageUrl(doc) != null
              ? NetworkImage(_getImageUrl(doc)!)
              : AssetImage('assets/images/doc.png'),
        ),
        title: Text(doc['name']),
        subtitle: Text(doc['specialty']),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => DoctorProfileScreen(
                  name: doc['name'],
                  specialty: doc['specialty'],
                  imageUrl: _getImageUrl(doc),
                  experience: doc['experience'] ?? '0 years',
                  about: doc['about'] ?? 'No additional information provided.',
                ),
              ),
            );
          },
          child: Text('Book Appointment'),
        ),
      ),
    );
  }


  // Builds a card for each category with an icon and a click listener
  Widget _buildCategoryCard(BuildContext context, String specialty) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorCategoryScreen(specialty: specialty),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(specialtyIcons[specialty] ?? Icons.local_hospital, size: 40),
              SizedBox(height: 10),
              Text(specialty, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  // Extract imageUrl with proper null-check
  String? _getImageUrl(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return data.containsKey('imageUrl') ? data['imageUrl'] as String : null;
  }
}

class DoctorCategoryScreen extends StatelessWidget {
  final String specialty;

  DoctorCategoryScreen({required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$specialty Doctors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .where('specialty', isEqualTo: specialty)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No doctors found for this category.'));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];
              return _buildDoctorCard(context, doc);
            },
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DocumentSnapshot doc) {
    final String name = doc['name'];
    final String specialty = doc['specialty'];
    final String? imageUrl = _getImageUrl(doc);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl != null
              ? NetworkImage(imageUrl)
              : AssetImage('assets/images/doc.png'),
        ),
        title: Text(name),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorProfileScreen(
                  name: name,
                  specialty: specialty,
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
          child: Text('Book Appointment'),
        ),
      ),
    );
  }

  // Extract imageUrl with proper null-check
  String? _getImageUrl(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return data.containsKey('imageUrl') ? data['imageUrl'] as String : null;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditDoctorProfile extends StatefulWidget {
  final String doctorId;

  EditDoctorProfile({required this.doctorId});

  @override
  _EditDoctorProfileState createState() => _EditDoctorProfileState();
}

class _EditDoctorProfileState extends State<EditDoctorProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List<String> availableDays = [];
  File? _imageFile;
  String? existingImageUrl;
  bool isLoading = true;
  bool loader=false;
  @override
  void initState() {
    super.initState();
    fetchDoctorProfile();
  }

  Future<void> fetchDoctorProfile() async {
    // Fetch the doctor profile from Firestore
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorId)
        .get();

    if (doctorDoc.exists) {
      Map<String, dynamic> data = doctorDoc.data() as Map<String, dynamic>;

      setState(() {
        nameController.text = data['name'] ?? '';
        experienceController.text = data['experience'] ?? '';
        aboutController.text = data['about'] ?? '';
        startTimeController.text = data['startTime'] ?? '';
        endTimeController.text = data['endTime'] ?? '';
        availableDays = List<String>.from(data['availableDays'] ?? []);
        existingImageUrl = data['profileImageUrl'];
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }



  Future<void> saveProfile() async {
    // Show a loading indicator if needed
    loader=true;
    String? imageUrl = existingImageUrl;

    // If a new image is picked, upload it and get the URL
    if (_imageFile != null) {
      try {
        // Define a unique path for the image in Firebase Storage
        String filePath = 'doctorProfiles/${widget.doctorId}/${DateTime.now().millisecondsSinceEpoch}.png';

        // Create a reference to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);

        // Upload the file
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        // Optionally, show an error message to the user
      }
    }

    // Prepare updated profile data
    Map<String, dynamic> updatedData = {
      'name': nameController.text,
      'experience': experienceController.text,
      'about': aboutController.text,
      'startTime': startTimeController.text,
      'endTime': endTimeController.text,
      'availableDays': availableDays,
      'profileImageUrl': imageUrl, // Use the new or existing image URL
    };

    // Update Firestore
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorId)
          .update(updatedData);

      // Optionally, show a success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully'),
      ));
       Navigator.pop(context);
      // Navigate back or perform another action on success
    } catch (e) {
      print('Error updating profile: $e');
      // Optionally, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating profile'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        backgroundColor: Color(0xFFABD5D5),
        title: Text('Edit Doctor Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (existingImageUrl != null
                        ? NetworkImage(existingImageUrl!)
                        : const AssetImage('assets/images/doc.png'))
                    as ImageProvider<Object>,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: experienceController,
                decoration: InputDecoration(labelText: 'Experience'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: aboutController,
                decoration: InputDecoration(labelText: 'About'),
              ),
              SizedBox(height: 10),
              Text('Available Days'),
              Wrap(
                spacing: 8.0,
                children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                    .map((day) => ChoiceChip(
                  label: Text(day),
                  selected: availableDays.contains(day),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        availableDays.add(day);
                      } else {
                        availableDays.remove(day);
                      }
                    });
                  },
                ))
                    .toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(labelText: 'End Time'),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: saveProfile,
                  child:loader?CircularProgressIndicator(): Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

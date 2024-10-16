import 'package:care_connect/Doctors/DoctorLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For formatting time

class DoctorSignUpScreen extends StatefulWidget {
  @override
  _DoctorSignUpScreenState createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController feesController = TextEditingController();

  String? selectedSpecialty;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool isLoading = false;

  // Available specialties
  List<String> specialties = [
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Pediatrician',
    'General Physician',
  ];

  // Available days
  List<String> availableDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> selectedDays = [];

  // Function to format TimeOfDay to readable string
  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // Use 12-hour format
    return format.format(dt);
  }

  // Function to pick a time using the time picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Function to handle user registration
  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        experienceController.text.isEmpty ||
        selectedSpecialty == null ||
        _startTime == null ||
        _endTime == null ||
        feesController.text.isEmpty ||
        aboutController.text.isEmpty ||
        selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select available days')),
      );
      return; // Stop further execution if validation fails
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Firebase authentication signup
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user data in Firestore
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'uid': userCredential.user!.uid,
        'specialty': selectedSpecialty,
        'experience': experienceController.text.trim(),
        'startTime': _formatTime(_startTime),
        'endTime': _formatTime(_endTime),
        'fee': int.parse(feesController.text.trim()),
        'about': aboutController.text.trim(),
        'availableDays': selectedDays, // Save selected available days
        'createdAt': DateTime.now(),
        'people': 0,
        'rating': 0.0,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doctor account created successfully')),
      );
      // Navigate to login screen after successful signup
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => DoctorLoginScreen()));

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset(
                'assets/images/signup_screen.png',
                height: 150,
              ),
              SizedBox(height: 20),
              // Name TextField
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Phone Number TextField
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: feesController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Fee',
                  prefixIcon: Icon(Icons.monetization_on),
                  hintText: 'Enter your fee in rupees',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Specialty Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Specialty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                value: selectedSpecialty,
                items: specialties.map((specialty) {
                  return DropdownMenuItem(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpecialty = value;
                  });
                },
                hint: Text('Select your specialty'),
              ),
              SizedBox(height: 15),
              // Experience TextField
              TextField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Experience (years)',
                  prefixIcon: Icon(Icons.work_outline),
                  hintText: 'Enter your experience in years',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // About TextField
              TextField(
                controller: aboutController,
                decoration: InputDecoration(
                  labelText: 'About',
                  prefixIcon: Icon(Icons.info_outline),
                  hintText: 'Tell us about yourself',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Start Time Picker
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: _formatTime(_startTime)),
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // End Time Picker
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: _formatTime(_endTime)),
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Available Days Checkboxes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: availableDays.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedDays.contains(day),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              // SignUp Button
              ElevatedButton(
                onPressed: isLoading ? null : signUp,
                child: isLoading ? CircularProgressIndicator() : Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

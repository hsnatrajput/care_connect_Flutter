import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'find_doctor.dart';

class TimeSlotSelectionScreen extends StatefulWidget {
  final String doctorId;
  final String? patientName;
  final String? phoneNumber;
  final String? weight;
  final String? gender;
  final String? problemDescription;
final String? age;
  TimeSlotSelectionScreen({required this.doctorId, this.patientName, this.phoneNumber, this.weight, this.gender, this.problemDescription,  this.age});

  @override
  _TimeSlotSelectionScreenState createState() => _TimeSlotSelectionScreenState();
}

class _TimeSlotSelectionScreenState extends State<TimeSlotSelectionScreen> {
  Map<String, dynamic>? doctorData;
  String? selectedDay;
  String? selectedTimeSlot;
  bool isLoading = false;
  List<String> bookedSlots = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorAvailability();
  }

  Future<void> _fetchDoctorAvailability() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorId)
          .get();

      if (doc.exists) {
        setState(() {
          doctorData = doc.data() as Map<String, dynamic>;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor data not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching doctor data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBookedSlots() async {
    if (selectedDay != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: widget.doctorId)
          .where('date', isEqualTo: selectedDay)
          .where('status', isEqualTo: 'booked')
          .get();

      setState(() {
        bookedSlots = snapshot.docs.map((doc) => doc['time'] as String).toList();
      });
    }
  }

  List<String> _generateTimeSlots(String startTime, String endTime) {
    DateTime start = DateFormat.jm().parse(startTime);
    DateTime end = DateFormat.jm().parse(endTime);

    List<String> timeSlots = [];
    DateTime current = start;

    while (current.isBefore(end)) {
      timeSlots.add(DateFormat.jm().format(current));
      current = current.add(Duration(minutes: 30)); // 30-minute intervals
    }

    return timeSlots;
  }

  Future<void> _bookAppointment() async {
    if (selectedDay == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a day and time slot')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Fetch doctor's fee from doctorData
      int fee = doctorData!['fee']; // Assuming fee is stored in doctor's data
      String currency = 'pkr'; // You can customize this based on your setup

      // Create a payment intent
      var paymentIntent = await createPaymentIntent(fee.toString(), currency);

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Doctor Appointment',
          style: ThemeMode.light,
          customerId: FirebaseAuth.instance.currentUser!.uid,
        ),
      );

      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // If payment is successful, save appointment to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'patientId': FirebaseAuth.instance.currentUser!.uid,
        'patientName': widget.patientName,
        'phoneNumber': widget.phoneNumber,
        'weight': widget.weight,
        'gender': widget.gender,
        'problemDescription': widget.problemDescription,
        'fee': fee,
        'age':widget.age,
        'date': selectedDay,
        'time': selectedTimeSlot,
        'status': 'booked',
        'createdAt': DateTime.now(),
      });
      await FirebaseFirestore.instance.collection('doctors').doc(widget.doctorId).update({
        'people': FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );

      // Navigate to confirmation or home screen
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FindDoctorScreen()));
    } on StripeException catch (e) {
      _handleStripeError(e);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking appointment: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ' +
              'sk_test_51PKey5RqpLRvpy66026DAL2U96UAKIrKYXiy7sfu9axdFdhA6TGYnzTqrWESzEEnm3g5Nvfeg8dAb6uDtFqv2lZU00GJ7Aj09N',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      print('Create Intent response ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      throw Exception('Payment intent creation failed');
    }
  }

  String calculateAmount(String amount) {
    final intAmount = (int.parse(amount)) * 100;
    return intAmount.toString(); // Stripe expects the amount in cents
  }

  void _handleStripeError(StripeException e) {
    String errorMessage;

    if (e.error.code == 'canceled') {
      errorMessage = 'Payment was cancelled by the user.';
    } else if (e.error.code == 'card_declined') {
      errorMessage = 'Your card was declined. Please try another card.';
    } else if (e.error.code == 'expired_card') {
      errorMessage = 'Your card has expired. Please use a valid card.';
    } else if (e.error.code == 'incorrect_cvc') {
      errorMessage = 'The CVC code is incorrect. Please check and try again.';
    } else if (e.error.code == 'processing_error') {
      errorMessage = 'There was a processing error. Please try again later.';
    } else {
      errorMessage = 'Payment failed: ${e.error.message ?? 'An unknown error occurred.'}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || doctorData == null) {
      return Scaffold(
        backgroundColor: Color(0xFFABD5D5),
        appBar: AppBar(
          title: Text('Select Time Slot'),
          backgroundColor: Colors.teal,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<String> availableDays = doctorData!['availableDays'].cast<String>();
    List<String> availableTimeSlots = selectedDay != null
        ? _generateTimeSlots(doctorData!['startTime'], doctorData!['endTime'])
        : [];

    if (selectedDay != null) {
      _fetchBookedSlots();
    }

    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Select Time Slot'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Days',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableDays.map((day) {
                  bool isSelected = selectedDay == day;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                        selectedTimeSlot = null; // Reset selected time slot
                        bookedSlots.clear(); // Clear booked slots when day changes
                      });
                      _fetchBookedSlots(); // Fetch booked slots for the selected day
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.teal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: availableTimeSlots.length,
                itemBuilder: (context, index) {
                  String timeSlot = availableTimeSlots[index];
                  bool isBooked = bookedSlots.contains(timeSlot);
                  bool isSelected = selectedTimeSlot == timeSlot;

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () {
                      setState(() {
                        selectedTimeSlot = timeSlot;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.redAccent
                            : (isSelected ? Colors.teal : Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.teal),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isBooked ? Colors.white : (isSelected ? Colors.white : Colors.teal),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'medicineModel.dart';

class MedicineListScreen extends StatefulWidget {
  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  Map<String, dynamic>? paymentIntentData;
  TextEditingController addressController = TextEditingController();

  final List<Medicine> medicines = [
    Medicine(name: "Paracetamol", price: 10.0),
    Medicine(name: "Ibuprofen", price: 15.0),
    Medicine(name: "Aspirin", price: 12.0),
    Medicine(name: "Amoxicillin", price: 25.0),
    Medicine(name: "Ciprofloxacin", price: 18.0),
    Medicine(name: "Metformin", price: 22.0),
    Medicine(name: "Atorvastatin", price: 30.0),
    Medicine(name: "Omeprazole", price: 17.0),
    Medicine(name: "Lisinopril", price: 20.0),
    Medicine(name: "Azithromycin", price: 19.0),
    Medicine(name: "Prednisone", price: 28.0),
    Medicine(name: "Hydrochlorothiazide", price: 14.0),
    Medicine(name: "Levothyroxine", price: 26.0),
    Medicine(name: "Losartan", price: 23.0),
    Medicine(name: "Gabapentin", price: 29.0),
    Medicine(name: "Albuterol", price: 16.0),
    Medicine(name: "Warfarin", price: 21.0),
    Medicine(name: "Clopidogrel", price: 24.0),
    Medicine(name: "Simvastatin", price: 27.0),
    Medicine(name: "Metoprolol", price: 18.0),
    Medicine(name: "Furosemide", price: 13.0),
    Medicine(name: "Amlodipine", price: 25.0),
    Medicine(name: "Doxycycline", price: 26.0),
    Medicine(name: "Montelukast", price: 22.0),
    Medicine(name: "Rosuvastatin", price: 31.0),
    Medicine(name: "Salbutamol", price: 15.0),
    Medicine(name: "Loratadine", price: 10.0),
    Medicine(name: "Esomeprazole", price: 23.0),
    Medicine(name: "Pantoprazole", price: 19.0),
    Medicine(name: "Cetirizine", price: 14.0),
    Medicine(name: "Allopurinol", price: 17.0),
    Medicine(name: "Gliclazide", price: 18.0),
    Medicine(name: "Spironolactone", price: 21.0),
    Medicine(name: "Ranitidine", price: 20.0),
    Medicine(name: "Erythromycin", price: 24.0),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB8E6E6),
        title: Text('Medicine List'),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return ListTile(
            title: Text(medicine.name),
            subtitle: Text("\$${medicine.price.toString()}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              _showAddressDialog(medicine);
            },
          );
        },
      ),
    );
  }

  void _showAddressDialog(Medicine medicine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Delivery Address'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: "Enter your address"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Proceed to Payment'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                makePayment(medicine.price.toString(), 'USD', medicine.name);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> makePayment(String amount, String currency, String medicineName) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Pharmacy',
          style: ThemeMode.light,
        ),
      );

      displayPaymentSheet(medicineName, amount);
    } catch (e, s) {
      print('Payment exception: $e$s');
    }
  }

  displayPaymentSheet(String medicineName, String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        print('payment intent: ' + paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful for $medicineName")),
        );

        saveToFirestore(medicineName, amount, addressController.text);
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Payment Cancelled"),
          ));
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51PKey5RqpLRvpy66026DAL2U96UAKIrKYXiy7sfu9axdFdhA6TGYnzTqrWESzEEnm3g5Nvfeg8dAb6uDtFqv2lZU00GJ7Aj09N',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      print('Create Intent response ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      throw Exception('Failed to create payment intent');
    }
  }

  String calculateAmount(String amount) {
    final a = (double.parse(amount) * 100).toInt();
    return a.toString();
  }

  Future<void> saveToFirestore(String medicineName, String price, String address) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      // Save the order details in Firestore
      await FirebaseFirestore.instance.collection('medicine_orders').add({
        'userId': userId,
        'medicineName': medicineName,
        'price': price,
        'address': address,
        'orderDate': DateTime.now(),
      });

      // Save the notification in Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'message': 'Payment successfully sent and order placed for $medicineName.',
        'timestamp': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notification added: Payment and order successful")),
      );
    }
  }
}

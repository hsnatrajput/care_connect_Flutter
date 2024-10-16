import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

import 'medicineModel.dart';



class MedicineListScreen extends StatefulWidget {
  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  Map<String, dynamic>? paymentIntentData;

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
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              makePayment(medicine.price.toString(), 'USD', medicine.name);
            },
          );
        },
      ),
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

      displayPaymentSheet(medicineName);
    } catch (e, s) {
      print('Payment exception: $e$s');
    }
  }

  displayPaymentSheet(String medicineName) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        print('payment intent: ' + paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful for $medicineName")),
        );

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
}

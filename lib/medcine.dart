import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medicineModel.dart';

class MedicineListScreen extends StatefulWidget {
  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Medicine> filteredMedicines = [];

  final List<Medicine> medicines = [
    Medicine(name: "Paracetamol", price: 10.0, imageUrl: 'https://th.bing.com/th/id/OIP.Ro2MSWVL2Ykmyvvi2BcWgQHaHa?rs=1&pid=ImgDetMain'),
    Medicine(name: "Ibuprofen", price: 15.0, imageUrl: 'https://www.emeds.pk/upload/pro-imges/image-18/33a.webp'),
    Medicine(name: "Aspirin", price: 12.0, imageUrl: 'https://image.made-in-china.com/2f0j00moDVdSKseMRN/Aspirin-Tablets-300mg-10X10-prime-S-Box-Western-Medicine.jpg'),
    Medicine(name: "Amoxicillin", price: 25.0, imageUrl: 'https://www.emeds.pk/upload/pro-imges/image-20/amoxil-125mg-(20ml).webp'),
    Medicine(name: "Ciprofloxacin", price: 18.0, imageUrl: 'https://5.imimg.com/data5/KH/VX/MY-2764690/ciprofloxacin-tablets-usp-500-mg.jpg'),
    Medicine(name: "Metformin", price: 22.0, imageUrl: 'https://www.emeds.pk/upload/pro-imges/image-3/metformina-850mg.webp'),
    Medicine(name: "Atorvastatin", price: 30.0, imageUrl: 'https://www.emeds.pk/upload/pro-imges/image-12/0139.webp'),
    Medicine(name: "Omeprazole", price: 17.0, imageUrl: 'https://th.bing.com/th/id/OIP.onzXjk_8WXEgY0mTmIDA_AAAAA?rs=1&pid=ImgDetMain'),
    Medicine(name: "Lisinopril", price: 20.0, imageUrl: 'https://th.bing.com/th/id/R.9316490ce3a595e01e2547aa8d77195a?rik=qzi7Uszeyz0E1Q&pid=ImgRaw&r=0'),
    Medicine(name: "Azithromycin", price: 19.0, imageUrl: 'https://th.bing.com/th/id/OIP.JbTeD_skIlYV75kP3ylPjwHaE0?w=740&h=481&rs=1&pid=ImgDetMain'),
    Medicine(name: "Prednisone", price: 28.0, imageUrl: 'https://th.bing.com/th/id/OIP.kUe4ddCh1_37QzJUyq_dtQAAAA?w=360&h=360&rs=1&pid=ImgDetMain'),
    Medicine(name: "Hydrochlorothiazide", price: 14.0, imageUrl: 'https://th.bing.com/th/id/OIP.OITyq4OrzOpDPnbhtpB6TQHaHa?rs=1&pid=ImgDetMain'),
    Medicine(name: "Levothyroxine", price: 26.0, imageUrl: 'https://th.bing.com/th/id/OIP.KWT_NGybd0bq7ZYsqwN_EgHaE1?rs=1&pid=ImgDetMain'),
    Medicine(name: "Losartan", price: 23.0, imageUrl: 'https://th.bing.com/th/id/OIP.PhigLkyFVzBrbevtLGnRxAHaEM?rs=1&pid=ImgDetMain'),
    Medicine(name: "Gabapentin", price: 29.0, imageUrl: 'https://th.bing.com/th/id/OIP.2EyfHM6mLbKucunxrzSPVQHaGH?w=750&h=619&rs=1&pid=ImgDetMain'),
    Medicine(name: "Albuterol", price: 16.0, imageUrl: 'https://th.bing.com/th/id/R.1ed1cc055ad805bf4f4ecf4bc6bef965?rik=wI35Or3%2buq3gog&riu=http%3a%2f%2fwellnesschronicle.com%2fwp-content%2fuploads%2f2015%2f09%2fAlbuterol.jpg&ehk=StPsPKFI8%2bLNjJ2cHlJR592d4JoGT9PMMID9EJMeckc%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1'),
    Medicine(name: "Warfarin", price: 21.0, imageUrl: 'https://th.bing.com/th/id/R.c40e59f96937a542fe2b30d13a8b6f1c?rik=c8HYXyjaNIJTRA&pid=ImgRaw&r=0'),
    Medicine(name: "Clopidogrel", price: 24.0, imageUrl: 'https://th.bing.com/th/id/R.b32e2929a8dd609f005de2e35de99c0b?rik=5NNy2iEobxFJYA&pid=ImgRaw&r=0'),
    Medicine(name: "Simvastatin", price: 27.0, imageUrl: 'https://th.bing.com/th/id/R.26bc48e71a9a6c350465ea1aff11155e?rik=HGSu1HHYpBl0oQ&pid=ImgRaw&r=0&sres=1&sresct=1'),
    Medicine(name: "Metoprolol", price: 18.0, imageUrl: 'https://th.bing.com/th/id/OIP.KoYUWUdePs8AEQUYdIMqWwHaEH?rs=1&pid=ImgDetMain'),
  ];
  Map<String, dynamic>? paymentIntentData;
  @override
  void initState() {
    super.initState();
    filteredMedicines = medicines;
    searchController.addListener(() {
      filterMedicines();
    });
  }

  void filterMedicines() {
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        return medicine.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB8E6E6),
        title: Center(child: Text('Medicine')),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for medicine',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                return GestureDetector(
                  onTap: () {
                    _showAddressDialog(medicine);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              medicine.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            medicine.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "\$${medicine.price.toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
    print(medicineName);
    print(amount);
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
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
      await stripe.Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful for $medicineName")),
        );

        saveToFirestore(medicineName, amount, addressController.text);
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on stripe.StripeException catch (e) {
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
    final intAmount = (double.parse(amount) * 100).toInt();
    return intAmount.toString(); // Stripe expects the amount in cents as an integer
  }


  /*void _handleStripeError(StripeException e) {
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
  }*/


  void saveToFirestore(String medicineName, String amount, String address) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    await firestore.collection('medicine_orders').add({
      'userId': user?.uid,
      'medicineName': medicineName,
      'price': amount,
      'address': address,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'message': 'Payment successfully sent and Order Placed for ${medicineName}.',
      'timestamp': DateTime.now(),
    });
    addressController.clear();
  }
}

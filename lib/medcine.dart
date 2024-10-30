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
  Map<String, int> cart = {};  // Cart to hold medicine name and quantity
  Map<String, dynamic>? paymentIntentData;

  final List<Medicine> medicines = [
    // Your medicine list...
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

  @override
  void initState() {
    super.initState();
    filteredMedicines = medicines;
    searchController.addListener(filterMedicines);
  }

  void filterMedicines() {
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        return medicine.name.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  double calculateTotalPrice() {
    double total = 0.0;
    cart.forEach((name, quantity) {
      final medicine = medicines.firstWhere((med) => med.name == name);
      total += medicine.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB8E6E6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFB8E6E6),
        title: Center(child: Text('Medicine')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: cart.isNotEmpty ? Colors.red : Colors.black, // Change color if cart is not empty
            ),
            onPressed: _showCartDialog,
          ),
        ],
      ),
      body: Column(
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
                final quantity = cart[medicine.name] ?? 0; // Get quantity from cart

                return Card(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: quantity > 0
                                ? () {
                              setState(() {
                                if (cart[medicine.name]! > 1) {
                                  cart[medicine.name] = cart[medicine.name]! - 1;
                                } else {
                                  cart.remove(medicine.name); // Remove from cart if quantity is 0
                                }
                              });
                            }
                                : null,
                          ),
                          Text(
                            quantity > 0 ? "$quantity" : "0",
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                cart[medicine.name] = quantity + 1; // Increase quantity
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Display the total amount below the GridView
          cart.isNotEmpty?Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: ()=>_showCartDialog(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
              
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Total Amount: \$${calculateTotalPrice().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Icon(Icons.shopping_cart)
                  ],
                ),
              ),
            ),
          ):SizedBox.shrink(),
        ],
      ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            cart.clear();
          });
        },
        child: Icon(Icons.clear),
        backgroundColor: Colors.red,
        tooltip: 'Clear Cart',
      )
          : null,
    );
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cart Items'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: InputDecoration(hintText: "Enter your address"),
              ),
              SizedBox(height: 10),
              ...cart.entries.map((entry) {
                final medicine = medicines.firstWhere((med) => med.name == entry.key);
                return ListTile(
                  title: Text(medicine.name),
                  subtitle: Text("Qty: ${entry.value}"),
                  trailing: Text("\$${(medicine.price * entry.value).toStringAsFixed(2)}"),
                );
              }),
              Divider(),
              Text("Total: \$${calculateTotalPrice().toStringAsFixed(2)}"),
            ],
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
                Navigator.of(context).pop();
                makePayment(
                  calculateTotalPrice().toString(),
                  'USD',
                  cart.entries.map((e) => e.key).join(", "),
                );
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> makePayment(String amount, String currency, String medicineNames) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Pharmacy',
          style: ThemeMode.light,
        ),
      );

      displayPaymentSheet(medicineNames, amount);
    } catch (e, s) {
      print('Payment exception: $e$s');
    }
  }

  displayPaymentSheet(String medicineNames, String amount) async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful for $medicineNames")),
        );

        // Updated loop to iterate over cart entries
        for (var entry in cart.entries) {
          final medicineName = entry.key; // Medicine name
          final quantity = entry.value; // Quantity
          final medicine = medicines.firstWhere((med) => med.name == medicineName); // Get the medicine object
          saveToFirestore(medicineName, (medicine.price * quantity).toString(), addressController.text);
        }

        paymentIntentData = null;
        cart.clear(); // Clear cart after payment
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
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51PKey5RqpLRvpy66026DAL2U96UAKIrKYXiy7sfu9axdFdhA6TGYnzTqrWESzEEnm3g5Nvfeg8dAb6uDtFqv2lZU00GJ7Aj09N',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
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
      'message': "Order placed for $medicineName. Total amount: $amount",
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

import 'package:care_connect/splash_screen.dart';
import 'package:care_connect/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey  ='pk_test_51PKey5RqpLRvpy66lVzEVRMZnSlIwFBQFYbZqVRtrhiMyisPC2EvLjTlj0wMGfgIuLWSvuzt19jLBVKbPHQW85np003xB4VDJj';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CareConnectScreen(),  // This ensures Directionality and other features
      debugShowCheckedModeBanner: false,  // To hide the debug banner
    );
  }
}

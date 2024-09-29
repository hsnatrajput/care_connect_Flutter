import 'package:care_connect/splash_screen.dart';
import 'package:care_connect/start_screen.dart';
import 'package:flutter/material.dart';


void main() {
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

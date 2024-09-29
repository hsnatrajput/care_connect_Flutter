import 'package:care_connect/signup_screen.dart';
import 'package:flutter/material.dart';



class EnterOTPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button action here
          },
        ),
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code sent to your email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Add your resend code action here
              },
              child: Text('Resend code'),
            ),
            Text('OTP expires in 09:00 minutes'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your verify email action here
              },
              child: Text('Verify email address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>EnterOTPScreen()));
                  },
                  child: Text('Forgot Password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

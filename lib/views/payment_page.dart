import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD), // Set the background color of the app bar
        title: Text('Payment'),
      ),
      body: Center(
        child: Text('Payment Page'),
      ),
    );
  }
}
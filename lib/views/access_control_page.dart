import 'package:flutter/material.dart';

class AccessControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD), // Set the background color of the app bar
        title: Text('Access Control'),
      ),
      body: Center(
        child: Text('Access Control Page'),
      ),
    );
  }
}
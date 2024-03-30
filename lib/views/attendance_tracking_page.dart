import 'package:flutter/material.dart';

class AttendanceTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD), // Set the background color of the app bar
        title: Text('Attendance Tracking'),
      ),
      body: Center(
        child: Text('Attendance Tracking Page'),
      ),
    );
  }
}

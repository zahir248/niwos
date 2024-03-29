import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Check if the user is swiping horizontally to the right
        if (details.delta.dx > 0) {
          // Close the app
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        // Check if the user is swiping horizontally to the left
        else if (details.delta.dx < 0) {
          // Close the app
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Scaffold(
        body: FutureBuilder<String?>(
          future: _getUsername(), // Retrieve the username asynchronously
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for data, show a loading indicator
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              // If data is available, display the username
              String? username = snapshot.data;
              return Center(
                child: Text('Welcome to the Dashboard, $username!'),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}

import 'package:flutter/material.dart';

import '/views/login_page.dart';
import '/views/reset_password_page.dart';

class UserDetailsPage extends StatelessWidget {
  final String username;
  final String employeeId;

  UserDetailsPage({required this.username, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Login Details'),
        backgroundColor: Color(0xFF004AAD),
      ),
      backgroundColor: Colors.grey[350],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      username,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Employee ID',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      employeeId,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Are these your details? If yes, Click Confirm to reset your password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Center( // Wrap the Row with Center widget
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Align buttons to the center
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), // Replace LoginPage() with the appropriate constructor if needed
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD8EBFD),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text('Back to Login', style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(width: 10), // Adjust the width as needed
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResetPasswordPage(username: username)), // Pass the username parameter to the ResetPasswordPage constructor
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004AAD),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text('Confirm', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
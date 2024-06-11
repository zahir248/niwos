import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/views/user_details_page.dart';
import '/main.dart';

class ForgotLoginDetailsPage extends StatefulWidget {
  @override
  _ForgotLoginDetailsPageState createState() => _ForgotLoginDetailsPageState();
}

class _ForgotLoginDetailsPageState extends State<ForgotLoginDetailsPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _verifyUser(BuildContext context) async {
    final id = _idController.text;
    final mobile = _mobileController.text;

    final response = await http.post(
      Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.retrieveUsernamePath}'),
      body: {
        'Niwos_ID': id,
        'PhoneNumber': mobile,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        final username = jsonData['username'] ?? 'Username not found';

        // Update the text field with employee ID
        _idController.text = id; // Update with the entered ID

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(username: username, employeeId: id),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to verify user. Please try again.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red[900],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to communicate with the server. Please try again later.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Login Details'),
        backgroundColor: Color(0xFF004AAD),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please enter your Employee ID number and Phone number to reset your login details.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ID No.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Phone No.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_idController.text.isEmpty || _mobileController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in all the fields'),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _verifyUser(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004AAD),
                  padding: const EdgeInsets.all(16),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
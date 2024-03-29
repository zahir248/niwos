import 'package:flutter/material.dart';

import '/controllers/login_password_page_controller.dart';

class LoginPasswordPage extends StatefulWidget {
  final String username;

  const LoginPasswordPage({Key? key, required this.username}) : super(key: key);

  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  String _password = '';
  bool _isPasswordVisible = false;

  late final LoginPasswordPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginPasswordPageController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(
                  'assets/niwos.png',
                  width: 250,
                  height: 250,
                ),
              ),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '*', // Red asterisk
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        style: TextStyle(color: Colors.grey),
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          //hintText: 'Please enter password', // Hint text
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            splashRadius: 24, // Set splash radius to prevent the ripple effect
                            highlightColor: Colors.transparent, // Set highlight color to transparent to remove the ripple effect
                            enableFeedback: false, // Disable feedback to prevent vibration on press
                            padding: EdgeInsets.zero, // Remove padding to prevent space around the icon
                            iconSize: 24, // Set icon size to match the icon size of other buttons
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(165, 50), // Adjust the minimum width and height of the button
                        backgroundColor: Color(0xFFD8EBFD),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black), // Set text font color to black
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter password'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.grey[900],
                            ),
                          );
                        } else {
                          _authenticateUser(); // Call the authentication method
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(165, 50), // Adjust the minimum width and height of the button
                        backgroundColor: Color(0xFF004AAD), // Background color for "Yes" button
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white), // Set text font color to black
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticateUser() {
    _controller.handleLoginButtonPress(widget.username, _password);
  }
}

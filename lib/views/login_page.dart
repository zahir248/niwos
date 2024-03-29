import 'package:flutter/material.dart';

import '../controllers/login_page_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageController _controller = LoginPageController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isFingerprintAuthenticating = false; // Track fingerprint authentication state

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
                            'Username',
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
                      TextField(
                        controller: _usernameController, // Assign the controller to the text field
                        readOnly: _isFingerprintAuthenticating, // Prevent keyboard when authenticating
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: InkWell(
                            onTap: () => _authenticateWithFingerprint(context),
                            child: Icon(Icons.fingerprint, size: 35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Get username from text field
                      String username = _usernameController.text.trim();
                      // Check if the username field is empty
                      if (username.isEmpty) {
                        // Display a message if the username field is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter username'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.grey[900],
                          ),
                        );
                      } else if (!_isFingerprintAuthenticating) {
                        // Only proceed if fingerprint authentication is not ongoing
                        // Perform username checking
                        bool usernameExists = await _controller.checkUsername(username);
                        if (usernameExists) {
                          await _controller.navigateToSecurityPicturePage(context, username); // Pass the username here
                        } else {
                          // Username does not exist
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Username does not exist'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red[900],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Color(0xFF004AAD), // Set button background color
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticateWithFingerprint(BuildContext context) async {
    setState(() {
      _isFingerprintAuthenticating = true; // Set fingerprint authentication state
    });

    await _controller.authenticate(context);

    setState(() {
      _isFingerprintAuthenticating = false; // Reset fingerprint authentication state
    });
  }
}

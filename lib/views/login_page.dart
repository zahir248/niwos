import 'package:flutter/material.dart';

import '../controllers/splash_screen_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashScreenController _splashScreenController =
    SplashScreenController();

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(), // Prevent overscroll effect
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
              const SizedBox(height: 200), // Add space between text and username field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity, // Set the width to match the parent's width
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
                        style: TextStyle(color: Colors.grey), // Set the text color to grey
                        decoration: InputDecoration(
                          filled: true, // Set to true to fill the background
                          fillColor: Colors.grey[200], // Specify the fill color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none, // Remove the border
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: Icon(Icons.fingerprint, size: 35), // Make the fingerprint icon bigger
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
                  width: double.infinity, // Set the width to match the parent's width
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
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
}

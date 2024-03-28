import 'package:flutter/material.dart';

class SecurityPicturePage extends StatelessWidget {
  const SecurityPicturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Picture Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Security Picture Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add any functionality here
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

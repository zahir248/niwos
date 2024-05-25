import 'dart:typed_data';
import 'package:flutter/material.dart';

import '/controllers/security_picture_controller.dart';

class SecurityPicturePage extends StatefulWidget {
  final String username;

  const SecurityPicturePage({Key? key, required this.username}) : super(key: key);

  @override
  _SecurityPicturePageState createState() => _SecurityPicturePageState();
}

class _SecurityPicturePageState extends State<SecurityPicturePage> {
  final SecurityPictureController _controller = SecurityPictureController();

  String getMaskedUsername(String username) {
    if (username.length <= 4) {
      return username;
    } else {
      return '${username.substring(0, 2)}${'*' * (username.length - 4)}${username.substring(username.length - 2)}!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Image.asset(
                'assets/niwos.png',
                width: 250,
                height: 250,
              ),
            ),
            Text(
              'Welcome, ${getMaskedUsername(widget.username)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Is this your Security Picture?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            FutureBuilder<Uint8List?>(
              future: _controller.fetchSecurityPicture(widget.username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/defaultSecurity.jpg', // Path to your default image asset
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 50),
                      _buildButtons(context),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Image.memory(
                        snapshot.data!,
                        width: 150,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/defaultSecurity.jpg', // Path to your default image asset
                            width: 150,
                            height: 150,
                          );
                        },
                      ),
                      SizedBox(height: 50),
                      _buildButtons(context),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
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
            minimumSize: Size(150, 50),
            backgroundColor: Color(0xFFD8EBFD),
          ),
          child: Text(
            'No',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            _controller.navigateToLoginPasswordPage(context, widget.username);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(150, 50),
            backgroundColor: Color(0xFF004AAD),
          ),
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
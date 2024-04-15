import 'package:flutter/material.dart';

import '/views/profile_update_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Setting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0), // Adjust the padding as needed
              child: SizedBox(
                width: 350, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the update profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Color(0xFF004AAD),
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0), // Adjust the padding as needed
              child: SizedBox(
                width: 350, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality for changing password
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Color(0xFF004AAD),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

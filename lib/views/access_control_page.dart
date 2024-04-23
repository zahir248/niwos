import 'package:flutter/material.dart';
import 'dart:async';

import '/models/access_control_page_model.dart';
import '/controllers/access_control_page_controller.dart';
import '/views/access_request_page.dart';
import '/views/access_history_page.dart';
import '/views/cancel_access_request_page.dart';

class AccessControlPage extends StatefulWidget {
  @override
  _AccessControlPageState createState() => _AccessControlPageState();
}

class _AccessControlPageState extends State<AccessControlPage> {

  final AccessController _accessController = AccessController();

  bool _isAccessScanning = false;
  List<String> _userAccessCodes = []; // Added user access codes list

  @override
  void initState() {
    super.initState();
    // Fetch the user's AccessCode when the page is opened
    _fetchUserAccessCodes(); // Updated method call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Access Control'),
      ),
      backgroundColor: Colors.grey[350],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(60, 16, 60, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        _showAccessDialog();
                      },
                      child: Column(
                        children: [
                          _isAccessScanning
                              ? CircularProgressIndicator()
                              : Icon(
                            Icons.contactless,
                            size: 40,
                            color: Color(0xFF004AAD),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _isAccessScanning
                                ? 'Scanning...Please wait until done'
                                : 'Access In/Out',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SubmitAccessRequestPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Submit Access Request",
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontSize: 15, // Adjust the font size as needed
                            ),
                          ),
                          SizedBox(width: 10), // Add space between text and icon
                          Icon(
                            Icons.arrow_forward_ios, // Icon for navigating forward
                            color: Color(0xFF004AAD),
                            size: 15, // Adjust the icon size as needed
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CancelAccessRequestPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel Access Request",
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontSize: 15, // Adjust the font size as needed
                            ),
                          ),
                          SizedBox(width: 8), // Add space between text and icon
                          Icon(
                            Icons.arrow_forward_ios, // Icon for navigating forward
                            color: Color(0xFF004AAD),
                            size: 15, // Adjust the icon size as needed
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewAccessRequestHistoryPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View Access Request History",
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontSize: 15, // Adjust the font size as needed
                            ),
                          ),
                          SizedBox(width: 8), // Add space between text and icon
                          Icon(
                            Icons.arrow_forward_ios, // Icon for navigating forward
                            color: Color(0xFF004AAD),
                            size: 15, // Adjust the icon size as needed
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to fetch the user's AccessCode from the database
  void _fetchUserAccessCodes() async {
    // Call the fetchUserAccessCodesFromServer method from the AccessController
    List<String> accessCodes = await _accessController.fetchUserAccessCodes(context);

    setState(() {
      _userAccessCodes = accessCodes;
    });
  }

  void _showAccessDialog() {
    _accessController.showAccessDialog(context, _startAccessNFCReading);
  }

  void _startAccessNFCReading() {
    setState(() {
      _isAccessScanning = true;
    });

    // Set a timer for the scanning process
    const Duration scanningTimeoutDuration = Duration(seconds: 5); // Adjust timeout duration as needed
    Timer scanningTimer = Timer(scanningTimeoutDuration, () {
      // If the scanning takes too long, show a dialog
      _showScanningErrorDialog();
    });

    NFCService.startAccessNFCReading(onDiscovered: (String tagData) {
      // Cancel the timer when NFC tag is discovered
      scanningTimer.cancel();

      // Process tag data here
      debugPrint('NFC Tag Data: $tagData');

      // Remove the first three characters from the tag data
      String cleanedTagData = tagData.substring(3);

      // Debug print to see the cleaned tag data
      //debugPrint('Cleaned NFC Tag Data: $cleanedTagData');

      // Check if the cleaned tag data matches any of the user's access codes
      bool accessGranted = _userAccessCodes.contains(cleanedTagData);

      if (accessGranted) {
        // If access is granted, display the access granted message
        _accessGranted();
      } else {
        // If access is denied, display the access denied message
        _accessDenied();
      }
    });
  }

  void _accessGranted() {
    setState(() {
      _isAccessScanning = false;
    });
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Access Granted!"),
          content: Text("You have access to this area."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _accessDenied() {
    setState(() {
      _isAccessScanning = false;
    });
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Access Denied!"),
          content: Text("You do not have access to this area."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showScanningErrorDialog() {
    setState(() {
      _isAccessScanning = false;
    });
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Scanning Error"),
          content: Text("An error occurred during the scanning process. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
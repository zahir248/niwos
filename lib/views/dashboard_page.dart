import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/views/attendance_tracking_page.dart';
import '/views/access_control_page.dart';
import '/views/payment_page.dart';
import '/views/profile_page.dart';
import '/controllers/dashboard_controller.dart';
import '/models/user_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _user; // Make _user nullable

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    try {
      User user = await DashboardController.getUserDetailsFromSharedPreferences();
      setState(() {
        _user = user;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Adjust padding as needed
            child: Center(
              child: Text(
                _user?.niwosID ?? '', // Display Niwos_ID if available
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey[350], // Background color of the body
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), // Rounded top left corner
                bottomRight: Radius.circular(20), // Rounded top right corner
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white, // Set the background color of the section to white
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Center the contents horizontally
                  children: [
                    Image.asset(
                      'assets/niwos3.png',
                      width: 120, // Adjust the width of the logo image
                      height: 120, // Adjust the height of the logo image
                    ),
                    Text(
                      _user?.fullName ?? '', // Display fullname
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20), // Add space between the name and the department
                    Text(
                      _user?.department ?? '', // Display department
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8), // Add space between the name and the department
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[350], // Use the scaffold background color
            height: 30, // Height of the space
          ),
          Container(
            color: Colors.grey[350], // Background color of the body
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30), // Add padding to the left and right
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.white, // Set the background color of the section to white
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AttendanceTrackingPage()),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(Icons.assignment, size: 40, color: Color(0xFF004AAD)), // Icon for Attendance Tracking
                                SizedBox(height: 8),
                                Text(
                                  'Attendance',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Tracking',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AccessControlPage()),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(Icons.security, size: 40, color: Color(0xFF004AAD)),
                                SizedBox(height: 8),
                                Text(
                                  'Access',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Control',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PaymentPage()),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(Icons.payment, size: 40, color: Color(0xFF004AAD)),
                                SizedBox(height: 8),
                                Text(
                                  'Payment',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage()),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(Icons.account_circle, size: 40, color: Color(0xFF004AAD)),
                                SizedBox(height: 8),
                                Text(
                                  'Profile',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[350], // Use the scaffold background color
            height: 30, // Height of the space
          ),
          Container(
            color: Colors.grey[350], // Background color of the body
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30), // Add padding to the left and right
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.white, // Set the background color of the section to white
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                    children: [
                      Center( // Center the text horizontally
                        child: Text(
                          'USER SUPPORT AND ASSISTANCE',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 30), // Add some space between the text and the icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                            },
                            child: Column(
                              children: [
                                Icon(Icons.help_outline, size: 40, color: Color(0xFF004AAD)), // Icon for FAQ
                                SizedBox(height: 8),
                                Text(
                                  'FAQ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                            },
                            child: Column(
                              children: [
                                Icon(Icons.notifications, size: 40, color: Color(0xFF004AAD)), // Icon for Notification
                                SizedBox(height: 8),
                                Text(
                                  'Notification',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                            },
                            child: Column(
                              children: [
                                Icon(Icons.feedback, size: 40, color: Color(0xFF004AAD)), // Icon for Feedback
                                SizedBox(height: 8),
                                Text(
                                  'Feedback',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Content of the third section
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[350], // Set the background color of the body to grey
              child: Center(
                //child: Text('Your content goes here'),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white, // Set the background color of the drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Colors.white, // Set the background color of the drawer header to match the app bar
                child: DrawerHeader(
                  child: Image.asset(
                    'assets/niwos.png',
                    width: 80, // Adjust the width of the logo image
                    height: 80, // Adjust the height of the logo image
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Color(0xFF004AAD)), // Set the color of the icon
                title: Text('Home'),
                onTap: () {
                  // Close the drawer
                  Navigator.pop(context);
                  // You can add any additional actions you want here
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Color(0xFF004AAD)), // Set the color of the icon
                title: Text('Setting'),
                onTap: () {
                  DashboardController.navigateToSettings(context); // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFF004AAD)), // Set the color of the icon
                title: Text('Logout'),
                onTap: () {
                  DashboardController.showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _getUserDetails(String username) async {
    try {
      User? user = await DashboardController.getUserDetails(username);
      if (user != null) {
        // User data is not null, proceed with displaying the data
        print('Fullname: ${user.fullName}, Department: ${user.department}');
      } else {
        // User data is null, handle this case (e.g., show error message)
        print('User data is null');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }
}

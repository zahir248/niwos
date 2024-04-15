import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/profile_page_controller.dart';
import '/models/userProfile_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = ProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Profile'),
      ),
      body: Container(
        color: Colors.grey[350],
        child: FutureBuilder(
          future: _profileController.fetchUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return buildProfileUI(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileUI(UserProfile? userProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: gradientCardSample(userProfile),
        ),
        SizedBox(height: 20),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Employee Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5), // Adjust the spacing between the text and icon as needed
                    Icon(Icons.info, color: Color(0xFF004AAD)), // Set the color of the icon
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildProfileInfo(userProfile),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProfileInfo(UserProfile? userProfile) {
    if (userProfile == null) {
      return Text('User profile data is null');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Profile Picture:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                image: userProfile.profileImage != null
                    ? DecorationImage(
                  image: MemoryImage(userProfile.profileImage!),
                  fit: BoxFit.cover,
                )
                    : DecorationImage(
                  image: AssetImage('assets/default.jpg'), // Provide a placeholder image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${userProfile.fullName}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Number: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.niwosID}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Position: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.positionName}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.departmentName}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Joined Date: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.startDate != null ? DateFormat('yyyy-MM-dd').format(userProfile.startDate!) : 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.email}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of Birth: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(userProfile.dateOfBirth!) : 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${userProfile.phoneNumber}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),      ],
    );
  }

  Widget gradientCardSample(UserProfile? userProfile) {
    if (userProfile == null) {
      return Center(child: Text('User profile data is null'));
    }
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF004AAD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'NI',
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'WOS',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    image: userProfile.profileImage != null
                        ? DecorationImage(
                      image: MemoryImage(userProfile.profileImage!),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/default.jpg'), // Provide a placeholder image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('${userProfile.fullName}', style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('${userProfile.positionName}', style: TextStyle(fontSize: 13, color: Color(0xFF004AAD))),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID No', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text('${userProfile.niwosID}', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text('${userProfile.phoneNumber}', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Joined Date', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text(DateFormat('yyyy-MM-dd').format(userProfile.startDate), style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('D.O.B', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text(DateFormat('yyyy-MM-dd').format(userProfile.dateOfBirth), style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Department', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text('${userProfile.departmentName}', style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email', style: TextStyle(fontSize: 11, color: Color(0xFF004AAD))),
                        SizedBox(height: 5),
                        Text('${userProfile.email}', style: TextStyle(fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

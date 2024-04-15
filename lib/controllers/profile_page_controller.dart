import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data'; // Import the typed_data library to use Uint8List

import '/models/userProfile_model.dart';
import '/main.dart';

class ProfileController {
  Future<String> getUsernameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return username;
  }

  Future<UserProfile> fetchUserInfo() async {
    String username = await getUsernameFromSharedPreferences();

    // Print the username for debugging
    print('Username sent to server: $username');

    final response = await http.get(
      Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.getUserProfileDataPath}?username=$username'),
    );

    if (response.statusCode == 200) {
      // Print the response body for debugging
      print('Response body: ${response.body}');

      final userProfileData = json.decode(response.body);

      // Decode the profile image from base64
      String profileImage = userProfileData['ProfileImage'];
      Uint8List? decodedImage;
      if (profileImage != null && profileImage.isNotEmpty) {
        decodedImage = base64Decode(profileImage);
      }

      // Parse the response body into a UserProfile object
      return UserProfile.fromJson(userProfileData, decodedImage);

    } else {
      // Print the error message for debugging
      print('Failed to load user data. Status code: ${response.statusCode}');

      // Throw an exception with an error message
      throw Exception('Failed to load user data');
    }
  }
}

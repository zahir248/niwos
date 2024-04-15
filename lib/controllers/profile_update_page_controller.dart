import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/profile_update_model.dart';
import '/main.dart';

class ProfileController {
  final ProfileModel _model = ProfileModel();

  Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      _model.setImageFile(File(pickedImage.path));
      return File(pickedImage.path);
    }
    return null;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return username;
  }

  Future<bool> uploadImage() async {
    File? imageFile = _model.getImageFile();
    if (imageFile == null) {
      return false;
    }

    String? username = await getUsername();
    if (username == null || username.isEmpty) {
      // Username not retrieved or empty
      return false;
    }

    // Prepare the image file as bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Base64 encode the image bytes
    String base64Image = base64Encode(imageBytes);

    // Prepare the request body
    Map<String, String> requestBody = {
      'username': username,
      'image': base64Image,
    };

    // Construct the complete URL with baseIpAddress and uploadImageProfilePath
    String uploadUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.uploadImageProfilePath}';

    // Make an HTTP POST request to upload the image
    try {
      http.Response response = await http.post(
        Uri.parse(uploadUrl), // Use the complete URL
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Image upload successful
        return true;
      } else {
        // Error occurred
        print('Failed to upload image: ${response.body}');
        return false;
      }
    } catch (e) {
      // Exception occurred
      print('Exception occurred while uploading image: $e');
      return false;
    }
  }
}

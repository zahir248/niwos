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

  Future<File?> pickSecurityImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      _model.setSecurityImageFile(File(pickedImage.path));
      return File(pickedImage.path);
    }
    return null;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return username;
  }

  Future<bool> uploadImage(File imageFile) async {
    if (imageFile == null) {
      return false;
    }

    String? username = await getUsername();
    if (username == null || username.isEmpty) {
      return false;
    }

    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, String> requestBody = {
      'username': username,
      'image': base64Image,
    };

    String uploadUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.uploadImageProfilePath}';

    try {
      http.Response response = await http.post(
        Uri.parse(uploadUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to upload image: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while uploading image: $e');
      return false;
    }
  }

  Future<bool> uploadSecurityImage(File imageFile) async {
    if (imageFile == null) {
      return false;
    }

    String? username = await getUsername();
    if (username == null || username.isEmpty) {
      return false;
    }

    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, String> requestBody = {
      'username': username,
      'security_image': base64Image,
    };

    String uploadUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.uploadSecurityImagePath}';

    try {
      http.Response response = await http.post(
        Uri.parse(uploadUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to upload security image: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while uploading security image: $e');
      return false;
    }
  }

  Future<bool> updateUsername(String newUsername) async {
    String? currentUsername = await getUsername();
    if (currentUsername == null || currentUsername.isEmpty) {
      return false;
    }

    Map<String, String> requestBody = {
      'current_username': currentUsername,
      'new_username': newUsername,
    };

    String updateUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.updateUsernamePath}';

    try {
      http.Response response = await http.post(
        Uri.parse(updateUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', newUsername);
          return true;
        } else {
          print('Failed to update username: ${responseBody['message']}');
          return false;
        }
      } else {
        print('Failed to update username: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while updating username: $e');
      return false;
    }
  }
}
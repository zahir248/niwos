import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '/main.dart';

class SecurityPictureModel {
  static Future<Uint8List?> fetchSecurityPicture(String username) async {
    try {
      print('Fetching security picture for username: $username');

      final response = await http.get(
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.securityPicturePath}?username=$username'),
      );
      if (response.statusCode == 200) {
        // Parse JSON response
        Map<String, dynamic> responseData = json.decode(response.body);
        // Extract encoded image data from JSON
        String? encodedImageData = responseData['security_image'];
        if (encodedImageData != null) {
          // Decode the encoded image data using base64Decode
          Uint8List? decodedImage = base64Decode(encodedImageData);
          return decodedImage;
        } else {
          throw Exception('No security image data found in response');
        }
      } else {
        throw Exception('Failed to load picture: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching security picture: $e');
      return null;
    }
  }
}

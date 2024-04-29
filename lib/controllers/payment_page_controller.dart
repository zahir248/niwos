import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/payment_page_model.dart';

class WalletController {
  Future<Wallet> fetchWalletInfo() async {
    try {
      String username = await getUsernameFromSharedPreferences();
      print('Username sent to server: $username'); // Debug line

      final url = Uri.parse('http://192.168.0.109/niwos_api/retrieve_wallet_information.php');

      final response = await http.post(
        url,
        body: {
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Wallet(
          balance: data['balance'],
          lastTransaction: data['lastTransaction'],
        );
      } else {
        throw Exception('Failed to load wallet information');
      }
    } catch (error) {
      throw Exception('Failed to connect to server: $error');
    }
  }

  Future<String> getUsernameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? ''; // Assuming 'username' is the key used to store the username
    return username;
  }
}
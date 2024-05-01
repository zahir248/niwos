import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '/models/payment_page_model.dart';
import '/views/payment_page.dart';
import '/main.dart';

class WalletController {
  Future<Wallet> fetchWalletInfo() async {
    try {
      String username = await getUsernameFromSharedPreferences();
      print('Username sent to server: $username'); // Debug line

      final url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.walletInformationPath}');

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

  Future<void> submitPayment(BuildContext parentContext, List<Map<String, dynamic>> tagDataList, String location, double amount, Function refreshPageCallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    print('Sending username: $username'); // Debug line

    for (var data in tagDataList) {
      // Prepare the data to be sent to the PHP script
      Map<String, dynamic> postData = {
        'username': username,
        'location': location,
        'amount': amount.toString(), // Convert amount to string
      };

      print('Data sent to server: $postData'); // Debug line

      // Send HTTP POST request to PHP script
      var response = await http.post(
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.submitPaymentPath}'),
        body: postData,
      );

      if (response.statusCode == 200) {
        // Data successfully submitted to the database
        print('Response from server: ${response.body}'); // Debug line

        // Check the response from the server
        var responseData = response.body;

        if (responseData.contains('Data inserted successfully')) {
          // Payment recorded successfully
          print('Data submitted successfully.');

          // Display SnackBar indicating successful payment record submission
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Payment transaction successfully"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green[900],
            ),
          );

          // Refresh the PaymentPage
          refreshPageCallback();

        } else if (responseData.contains('Insufficient Balance')) {
          // Insufficient balance
          print('Insufficient balance.');

          // Display SnackBar indicating insufficient balance
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Insufficient Balance. Please reload"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
        } else if (responseData.contains('Failed to update balance')) {
          // Failed to update balance
          print('Failed to update balance');

          // Display SnackBar indicating Failed to update balance
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Failed to update balance"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
        } else if (responseData.contains('Wallet not found')) {
          // Wallet not found
          print('Wallet not found.');

          // Display SnackBar indicating wallet not found
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Wallet not found"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
          } else if (responseData.contains('User not found')) {
          // User not found
          print('User not found.');

          // Display SnackBar indicating user not found
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("User not found"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
        } else if (responseData.contains('Required fields are missing')) {
          // Required fields are missing
          print('Required fields are missing.');

          // Display SnackBar indicating missing fields
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Required fields are missing"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
        } else {
          // Unexpected response
          print('Unexpected response: $responseData.');

          // Display SnackBar with the unexpected response
          PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("An unexpected response occurred"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red[900],
            ),
          );
        }
      } else {
        // Error occurred
        print('Error: ${response.reasonPhrase}');
        // Display SnackBar with the error message
        PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text("An error occurred: ${response.reasonPhrase}"),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red[900],
          ),
        );
      }
    }
  }

  void showPayDialog(BuildContext context, Function startNFCReading) {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information!"),
          content: Text("Make sure NFC is turned on in the phone. Tap your phone to the tag."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                startNFCReading();
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }
}
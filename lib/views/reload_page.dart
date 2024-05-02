import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/views/payment_page.dart';
import '/main.dart';

class ReloadPage extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  const ReloadPage({Key? key, required this.scaffoldMessengerKey}) : super(key: key);
  @override
  _ReloadPageState createState() => _ReloadPageState();
}

class _ReloadPageState extends State<ReloadPage> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  String _selectedAmount = ''; // Track the selected amount
  bool _isAmountValid = false;

  late Razorpay razorpay;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateAmount);
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }

  TextEditingController amountController = TextEditingController();
  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red[900],
      duration: Duration(seconds: 5),
    ));
  }

  void successHandler(PaymentSuccessResponse response) async {
    // Retrieve username from SharedPreferences
    String? username = _prefs.getString('username');

    if (username != null) {
      // Send transaction details to PHP script
      String amount = _amountController.text.trim();
      //print('Sending transaction for username: $username, amount: $amount'); // Debug line

      String url = 'http://${AppConfig.baseIpAddress}${AppConfig.updateWalletBalancePath}';

      // Send HTTP POST request
      var postResponse = await http.post(Uri.parse(url), body: {
        'username': username,
        'amount': amount,
      });

      if (postResponse.statusCode == 200) {
        // Transaction successful, handle success message
        //print('Transaction successful');

        // Display success message in app
        PaymentPage.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Reload successful'),
            backgroundColor: Colors.green[900],
            duration: Duration(seconds: 5),
          ),
        );

        // Redirect to the previous page
        Navigator.of(context).pop('refresh');
      } else {
        // Transaction failed, handle error
        print('Transaction failed');
      }
    } else {
      print('Username not found in SharedPreferences');
    }
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green[900],
      duration: Duration(seconds: 5),
    ));
  }

  void openCheckout() {
    String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      // Handle empty input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an amount.'),
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    try {
      double amount = double.parse(amountText);
      if (amount <= 0) {
        // Handle non-positive input
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid amount.'),
            backgroundColor: Colors.red[900],
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      var options = {
        "key": "rzp_test_ioqix0rVQYiyCH",
        "amount": (amount * 100).toInt(), // Convert to integer cents
        "name": "Reload",
        "description": "This is the test payment",
        "timeout": "180",
        "currency": "MYR",
        "prefill": {
          "contact": "1234567890",
          "email": "test@abc.com",
        }
      };
      razorpay.open(options);
    } catch (e) {
      // Handle parsing error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid amount format.'),
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _validateAmount() {
    setState(() {
      _isAmountValid = _amountController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Reload'),
      ),
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Add padding between the section and the app bar
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Container(
                color: Colors.white, // Set section color here
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Input field for amount
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Enter your amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              // Set background color to white
                              prefix: Text(
                                'RM ',
                                style: TextStyle(color: Colors.blue[800],
                                    fontWeight: FontWeight
                                        .bold), // Set prefix color and weight
                              ), // Prefix with 'RM'
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.blue[800],
                                fontWeight: FontWeight
                                    .bold), // Set prefix color and weight
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Add space between input field and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildOutlinedNumberButton('100'),
                        SizedBox(width: 10), // Add space between buttons
                        buildOutlinedNumberButton('200'),
                        SizedBox(width: 10), // Add space between buttons
                        buildOutlinedNumberButton('300'),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Add space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildOutlinedNumberButton('500'),
                        SizedBox(width: 10), // Add space between buttons
                        buildOutlinedNumberButton('1000'),
                        SizedBox(width: 10), // Add space between buttons
                        OutlinedNumberButton(
                          number: 'Other',
                          isOtherButton: true,
                          onPressed: () {
                            _clearAmountAndFocus(context);
                            _amountFocusNode.requestFocus();
                            setState(() {
                              _selectedAmount =
                              'Other'; // Set selected amount to "Other"
                            });
                          },
                          // Change button color based on selection
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            // Text color
                            backgroundColor: _selectedAmount == 'Other'
                                ? Color(0xFFD8EBFD)
                                : Colors.white,
                            // Change color if selected
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            // Adjust button padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 5), // Add space between section and "Reload Wallet" button
            Container(
              color: Colors.white, // Set background color to white
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: _isAmountValid
                            ? () {
                          openCheckout(); // Call openCheckout if amount is valid
                        }
                            : null, // Disable button if amount is not valid
                        child: Text('Reload Wallet'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Make button rounded
                          ),
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Color(0xFF004AAD),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOutlinedNumberButton(String number) {
    return OutlinedNumberButton(
      number: number,
      onPressed: () {
        _updateAmount(number);
        setState(() {
          _selectedAmount = number; // Update selected amount
        });
      },
      // Change button color based on selection
      style: OutlinedButton.styleFrom(
        primary: Colors.black,
        // Text color
        backgroundColor: _selectedAmount == number ? Color(0xFFD8EBFD) : Colors
            .white,
        // Change color if selected
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        // Adjust button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20), // Adjust the radius as needed
        ),
      ),
    );
  }

  void _updateAmount(String amount) {
    _amountController.text = '$amount';
  }

  void _clearAmountAndFocus(BuildContext context) {
    _amountController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

// Widget for outlined numbered buttons
class OutlinedNumberButton extends StatelessWidget {
  final String number;
  final bool isOtherButton;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  const OutlinedNumberButton({
    required this.number,
    this.isOtherButton = false,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style ?? OutlinedButton.styleFrom(),
      child: Text(
        isOtherButton ? number : 'RM $number', // Conditionally set button text
        style: TextStyle(fontSize: 14, color: Colors.black), // Text color
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/payment_page_controller.dart';
import '/models/payment_page_model.dart';
import '/views/reload_page.dart';
import '/views/transaction_page.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
}

class _PaymentPageState extends State<PaymentPage> {
  final WalletController _walletController = WalletController();
  late Future<Wallet> _walletInfo;
  String location = '';

  @override
  void initState() {
    super.initState();
    _walletInfo = _walletController.fetchWalletInfo(); // Fetch wallet info on page load
  }

  void refreshPage() {
    setState(() {
      // Update the state variables to refresh the wallet information
      _walletInfo = _walletController.fetchWalletInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: PaymentPage.scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF004AAD),
          title: Text('Payment'),
        ),
        backgroundColor: Colors.grey[350],
        body: SingleChildScrollView(
          child: FutureBuilder<Wallet>(
            future: _walletInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final wallet = snapshot.data!;
                String formattedLastTransaction =
                (wallet.lastTransaction.isNotEmpty)
                    ? DateFormat('EEEE, dd MMMM yyyy, HH:mm a')
                    .format(DateTime.parse(wallet.lastTransaction))
                    : '-';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: 270,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'NI',
                                        style: TextStyle(
                                          color: Color(0xFF004AAD),
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'WOS-Wallet',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              Text(
                                'Available Balance:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '\RM ${wallet.balance}',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(height: 21),
                              Text(
                                'Last Transaction:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                formattedLastTransaction,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                                _showPayDialog();
                              },
                              child: Column(
                                children: [
                                  _isPayScanning
                                      ? CircularProgressIndicator()
                                      : Icon(
                                    Icons.contactless,
                                    size: 40,
                                    color: Color(0xFF004AAD),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _isPayScanning
                                        ? 'Scanning...Please wait until done'
                                        : 'Pay',
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
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReloadPage(
                                      scaffoldMessengerKey: PaymentPage
                                          .scaffoldMessengerKey,
                                    ),
                                  ),
                                );
                                if (result == 'refresh') {
                                  refreshPage();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Reload Wallet Balance",
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
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionHistoryPage()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "View Transaction History",
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
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  bool _isPayScanning = false;

  void _showPayDialog() {
    _walletController.showPayDialog(context, _startPayNFCReading);
  }

  void _startPayNFCReading() {
    setState(() {
      _isPayScanning = true;
    });

    List<Map<String, dynamic>> tagDataList = [];

    Wallet.startPayNFCReading(onDiscovered: (String tagData) {
      // Process tag data here
      debugPrint('NFC Tag Data: $tagData');

      // Store tag data, date, and time together
      tagDataList.add({'tagData': tagData});

      // Check if tag data matches the accepted format
      if (tagData.substring(3) ==
          ('Pymnt_@cc3ss#24!&Tz#Cafeteria')) {
        setState(() {
          location = 'Cafeteria';
        });
      } else if (tagData.substring(3) ==
          ('Pymnt_@cc3ss#24!&Tz#VendingMachine')) {
        setState(() {
          location = 'Vending Machine';
        });
      }
    });

    // After a certain delay, stop scanning and display the alert dialog
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isPayScanning = false;
      });

      // Show alert dialog with tag data, date, and time if available; otherwise, display "Please scan again"
      showDialog(
        barrierDismissible: false, // Prevent dismissal by tapping outside
        context: context,
        builder: (BuildContext context) {
          TextEditingController _amountController =
          TextEditingController(); // Controller for the amount input field
          return AlertDialog(
            title: Text("Information!"),
            content: tagDataList.isEmpty
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tap the phone for a longer time."),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Close the dialog
                      },
                      child: Text("Dismiss"), // Button to dismiss the dialog
                    ),
                  ),
                ),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Add spacing between label and value
                        Text(
                          location, // Display the location value
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Inside the AlertDialog widget in the _startNFCReading method
            actions: [
              if (tagDataList.isNotEmpty)
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!tagDataList.any((data) =>
                      data['tagData'].substring(3) ==
                          ('Pymnt_@cc3ss#24!&Tz#Cafeteria') ||
                          data['tagData'].substring(3) ==
                              ('Pymnt_@cc3ss#24!&Tz#VendingMachine')))
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Message: Invalid NFC tag!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      SizedBox(height: 8),
                      // Add spacing between message and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close the dialog
                            },
                            child: Text(tagDataList.isEmpty
                                ? "Try Again"
                                : "Cancel"),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            onPressed: tagDataList.any((data) =>
                            data['tagData'].substring(3) ==
                                ('Pymnt_@cc3ss#24!&Tz#Cafeteria') ||
                                data['tagData'].substring(3) ==
                                    ('Pymnt_@cc3ss#24!&Tz#VendingMachine'))
                                ? () {
                              Navigator.pop(
                                  context); // Close the dialog
                              double amount = double.tryParse(
                                  _amountController.text) ??
                                  0;
                              if (amount <= 0) {
                                showDialog(
                                  barrierDismissible:
                                  false, // Prevent dismissal by tapping outside
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Invalid!"),
                                      content: Text(
                                          "Please enter a valid amount"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                _walletController.submitPayment(
                                    context,
                                    tagDataList,
                                    location,
                                    amount,
                                    refreshPage);
                              }
                            }
                                : null,
                            child: Text("Confirm"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      );
    });
  }
}
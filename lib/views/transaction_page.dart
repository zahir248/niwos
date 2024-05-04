import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/transaction_page_controller.dart';
import '/views/transaction_details_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TransactionController _controller = TransactionController();
  List<dynamic> transactionData = [];
  String selectedMethodType = '';

  @override
  void initState() {
    super.initState();
    _loadTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    // Sort transaction data by the latest transaction date time
    transactionData.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a['PaymentTimeDate']);
      DateTime dateTimeB = DateTime.parse(b['PaymentTimeDate']);
      return dateTimeB.compareTo(dateTimeA);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Transaction History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      backgroundColor: Colors.grey[350],
      body: Column(
        children: [
          Expanded(
            child: transactionData.isEmpty
                ? Center(
              child: Text(
                'No transaction records found',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: transactionData.length,
              itemBuilder: (BuildContext context, int index) {
                // Extract transaction data for the current index
                Map<String, dynamic> transaction = transactionData[index];
                double amount =
                double.parse(transaction['Amount'].replaceAll(',', ''));
                String paymentTimeDate = transaction['PaymentTimeDate'];
                String currency = transaction['Currency'];

                // Format the payment time date
                DateTime paymentDateTime =
                DateTime.parse(paymentTimeDate);
                String formattedDate = DateFormat('EEEE, d MMMM yyyy')
                    .format(paymentDateTime);
                String formattedTime =
                DateFormat('h:mm a').format(paymentDateTime);

                // Check if the transaction matches the selected MethodType or if 'All' is selected
                if (selectedMethodType.isEmpty ||
                    transaction['MethodType'] == selectedMethodType) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RM ${amount.toStringAsFixed(2)}', // Display amount with two decimal places
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 90, // Fixed width for the status indicator
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                      transaction['MethodType']),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${transaction['MethodType']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 0.3,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(vertical: 8),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                EdgeInsets.only(bottom: 8), // Add padding to the bottom
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today), // Date icon
                                    SizedBox(width: 8),
                                    Text(
                                      formattedDate, // Formatted date
                                      style: TextStyle(fontSize: 13), // Adjust font size
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                EdgeInsets.only(bottom: 8), // Add padding to the bottom
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time), // Time icon
                                    SizedBox(width: 8),
                                    Text(
                                      formattedTime, // Formatted time
                                      style: TextStyle(fontSize: 13), // Adjust font size
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailsPage(transaction: transaction),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF004AAD)),
                            ),
                            child: Text('Details'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // If not matching the selected MethodType, return an empty Container
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadTransactionData() async {
    try {
      final String? username = await _controller.getUsername();
      if (username != null && username.isNotEmpty) {
        final List<dynamic> data = await _controller.fetchTransactionData(username);
        setState(() {
          transactionData = data;
        });
      } else {
        print('Username not found');
      }
    } catch (error) {
      print(error);
    }
  }

  Color _getStatusColor(String methodType) {
    switch (methodType) {
      case 'Credit/Debit':
        return Colors.orange.shade900;
      case 'Wallet':
        return Colors.yellow.shade700;
      default:
        return Colors.blue.shade200; // Default color
    }
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Method'),
          content: DropdownButtonFormField(
            value: selectedMethodType,
            items: [
              DropdownMenuItem(
                child: Text('All'),
                value: '',
              ),
              DropdownMenuItem(
                child: Text('Credit/Debit'),
                value: 'Credit/Debit',
              ),
              DropdownMenuItem(
                child: Text('Wallet'),
                value: 'Wallet',
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                selectedMethodType = value ?? '';
                Navigator.pop(context); // Close the dialog
              });
            },
          ),
        );
      },
    );
  }
}
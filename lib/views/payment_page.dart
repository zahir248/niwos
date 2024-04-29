import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/payment_page_controller.dart';
import '/models/payment_page_model.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final WalletController _walletController = WalletController();
  late Future<Wallet> _walletInfo;

  @override
  void initState() {
    super.initState();
    _walletInfo = _walletController.fetchWalletInfo(); // Fetch wallet info on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Payment'),
      ),
      backgroundColor: Colors.grey[350],
      body: FutureBuilder<Wallet>(
        future: _walletInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final wallet = snapshot.data!;
            DateTime lastTransactionDateTime = DateTime.parse(wallet.lastTransaction);
            String formattedLastTransaction = DateFormat('EEEE, dd MMMM yyyy, HH:mm a').format(lastTransactionDateTime);
            return Column(
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
                SizedBox(height: 16),
              ],
            );
          }
        },
      ),
    );
  }
}
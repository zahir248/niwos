import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> transaction;

  TransactionDetailsPage({required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Determine the description based on the MethodType
    String description = '';
    if (transaction['MethodType'] == 'Credit/Debit') {
      description = 'Reload Wallet';
    } else if (transaction['MethodType'] == 'Wallet') {
      description = 'Make Payment';
    } else {
      description = 'Not specified';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTile('Amount:', '${_formatAmount(transaction['Amount'])}'),
            _buildTile('Transaction Date and Time:', _formatDate(transaction['PaymentTimeDate'])),
            _buildTile('Transaction Method:', transaction['MethodType']),
            _buildTile('Description:', description),
            _buildTile('Currency:', transaction['Currency']),
            _buildTile('Location Name:', transaction['LocationName']),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 16.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 16.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  String _formatDate(String dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('EEEE, d MMMM yyyy, hh:mm a').format(dateTime);
    } else {
      return 'Not specified';
    }
  }

  String _formatAmount(String amountString) {
    double amount = double.parse(amountString.replaceAll(',', ''));
    return amount.toStringAsFixed(2);
  }
}
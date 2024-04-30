import 'package:nfc_manager/nfc_manager.dart';

class Wallet {
  final String balance;
  final String lastTransaction;

  Wallet({required this.balance, required this.lastTransaction});

  static Future<void> startPayNFCReading({required Function(String) onDiscovered}) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            Ndef? ndef = Ndef.from(tag);
            if (ndef != null) {
              NdefMessage? message = await ndef.read();
              if (message != null) {
                for (NdefRecord record in message.records) {
                  List<int> payload = record.payload;
                  String data = String.fromCharCodes(payload);
                  onDiscovered(data);
                }
              }
            }
          },
        );
      }
    } catch (e) {
      print('Error reading NFC: $e');
    }
  }
}
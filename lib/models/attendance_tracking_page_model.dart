import 'package:nfc_manager/nfc_manager.dart';

class NFCService {
  static Future<void> startPunchInNFCReading({required Function(String) onDiscovered}) async {
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

  static Future<void> startPunchOutNFCReading({required Function(String) onDiscovered}) async {
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

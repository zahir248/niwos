import 'package:flutter/foundation.dart';

class LeaveRequestModel {
  final ValueNotifier<DateTime?> startDate = ValueNotifier(null);
  final ValueNotifier<DateTime?> endDate = ValueNotifier(null);
  String? typeOfLeave;
  String? reason;
}

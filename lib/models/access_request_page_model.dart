import 'package:flutter/foundation.dart';

class AccessRequestModel {
  final ValueNotifier<DateTime?> startTimeDate = ValueNotifier(null);
  final ValueNotifier<DateTime?> endTimeDate = ValueNotifier(null);
  String? nameOfArea;
  String? reason;
}
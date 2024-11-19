import 'package:intl/intl.dart';

class Utils {
  /// Get the current time as a formatted string
  static String getCurrentTimeStringRequest() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }
}

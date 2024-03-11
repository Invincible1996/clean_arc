/// author kevin
/// date 3/11/24 10:47

class DateFormatUtil {
  /// format DateTime to String eg: 2024-03-09 10:00:00
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  /// format DateTime to String eg: 2024-03-09
  static String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  /// format DateTime to String eg: 10:00:00
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}

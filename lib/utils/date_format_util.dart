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

  /// milliseconds to date String eg: 1615276800000 to 2024-03-09
  static String formatMillisecondsToDate(int milliseconds) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}

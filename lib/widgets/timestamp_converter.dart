import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static String customFormatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();

    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime today = DateTime(now.year, now.month, now.day);

    if (isSameDay(dateTime, today)) {
      // Display time for today
      return 'Today${formatTime(dateTime)}';
    } else if (isSameDay(dateTime, yesterday)) {
      // Display time for yesterday
      return 'Yesterday${formatTime(dateTime)}';
    } else {
      // Display full date for other days
      return formatDate(dateTime);
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}';
  }

  static String formatDate(DateTime dateTime) {
    String month = getMonthName(dateTime.month);
    return '$month ${dateTime.day}, ${dateTime.year}';
  }

  static String getMonthName(int month) {
    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
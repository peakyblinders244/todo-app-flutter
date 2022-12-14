import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }
}

extension DateTimeExt on DateTime {
  DateTime get date => DateTime(year, month, day);

  String formatDateTime() {
    return DateFormat('dd.MM.yyyy - HH:mm').format(this);
  }

  bool isToday() => date == DateTimeUtils.today();
}
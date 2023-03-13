import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime stringToDateTime(String dateString) {
  List<String> dateParts = dateString.split('-');
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);
  return DateTime(year, month, day);
}

String dateTimeToString(DateTime date) {
  return date.toString().substring(0, 10);
}

String dateTimeToStringReadable(DateTime date) {
  return DateFormat('d. MMMM y (EEEE)', 'sr_Latn').format(date);
}

TimeOfDay stringToTimeOfDay(String timeString) {
  List<String> timeParts = timeString.split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1]);
  return TimeOfDay(hour: hours, minute: minutes);
}

String timeOfDayTo24hFormatString(TimeOfDay time) {
  String formattedTime =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  return formattedTime; //
}

// nmg da verujem da me drka glupi najobicniji time of day 
// ubaci ovo svugde
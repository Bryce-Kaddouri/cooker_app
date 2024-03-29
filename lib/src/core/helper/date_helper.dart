//import intl
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  // get the full formatted date (Wednesday, 12 May 2021)
  static String getFullFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y').format(date);
  }

  // get the full formatted date but reduce (Wed, 12 Nov 2021)
  static String getFullFormattedDateReduce(DateTime date) {
    return DateFormat('E, d MMM y').format(date);
  }

  static String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String getFormattedDateAndTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  // get month name and year
  static String getMonthNameAndYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static int getNbWeekInYear(int year) {
    DateTime date = DateTime(year, 12, 31);
    int dayOfYear = getDayOfYear(date);
    int nbWeek = dayOfYear ~/ 7;
    return nbWeek;
  }

  static getDayOfYear(DateTime date) {
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    int dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return dayOfYear;
  }

  static int getNbDaysInYear(int year) {
    return year % 4 == 0 ? 366 : 365;
  }

  static int getNbDaysInMonth(DateTime date) {
    int month = date.month;
    int year = date.year;
    int nbDays = 0;
    if (month == 2) {
      nbDays = year % 4 == 0 ? 29 : 28;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      nbDays = 30;
    } else {
      nbDays = 31;
    }
    return nbDays;
  }

  static getNbWeekInMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int dayOfWeek = firstDayOfMonth.weekday;
    int nbDayInMonth = getNbDaysInMonth(date);
    int nbWeek = (dayOfWeek + nbDayInMonth) ~/ 7;
    return nbWeek;
  }

  // get the days of the week by the current date (monday, tuesday, ...)
  static List<DateTime> getDaysInWeek(DateTime date) {
    List<DateTime> days = [];
    int dayOfWeek = date.weekday;
    DateTime firstDayOfWeek = date.subtract(Duration(days: dayOfWeek - 1));
    for (int i = 0; i < 7; i++) {
      days.add(firstDayOfWeek.add(Duration(days: i)));
    }
    return days;
  }

  // method to get day in letter (ex: SUnday ==> Sun)
  static String getDayInLetter(DateTime date) {
    return DateFormat('E').format(date);
  }

  static String get24HourTime(TimeOfDay time) {
    DateTime now = DateTime.now().copyWith(hour: time.hour, minute: time.minute);
    return DateFormat('HH:mm').format(now);
  }
}

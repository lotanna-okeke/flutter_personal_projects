import 'dart:ui';

import 'package:intl/intl.dart';

var logoColors = {
  1: const Color.fromARGB(255, 170, 0, 0),
  2: const Color.fromARGB(255, 189, 191, 193),
  3: const Color.fromARGB(255, 50, 50, 50)
};

String formatNumberWithCommas(double number) {
  // Use the 'NumberFormat' class from the 'intl' package to format the number.
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(number);
}

void gettest() {
  String inputDate = formatMonth('06-SEP-23 01.44.37.453904 PM');

  // Parse the input date string
  final parsedDate = DateFormat("dd-MMM-yy hh.mm.ss.SSSSSS a").parse(inputDate);

  // Format the date as "dd/M/yyyy"
  final formattedDate = DateFormat("dd/M/yyyy").format(parsedDate);

  // Format the time as "HH:mm"
  final formattedTime = DateFormat("HH:mm").format(parsedDate);

  print("Formatted Date: $formattedDate");
  print("Formatted Time: $formattedTime");
}

String formatDateString(String input) {
  //this func converts the SEP to Sep
  final parts = input.split('-');
  final month = parts[1];
  final formattedMonth =
      month.substring(0, 1) + month.substring(1, 3).toLowerCase();
  final formattedDate = "${parts[0]}-$formattedMonth-${parts[2]}";
  return formattedDate;
}

String formatMonth(String inputDate) {
  // const inputDate = "06-SEP-23 01.44.37.453904 PM";
  final dateParts = inputDate.split(' ');

  final formattedDate =
      "${formatDateString(dateParts[0])} ${dateParts[1]} ${dateParts[2]}";

  return formattedDate;
}

String formatDate(String inputDate) {
  inputDate = formatMonth('06-SEP-23 01.44.37.453904 PM');

  // Parse the input date string
  final parsedDate = DateFormat("dd-MMM-yy hh.mm.ss.SSSSSS a").parse(inputDate);

  // Format the date as "dd/M/yyyy"
  final formattedDate = DateFormat("dd/M/yyyy").format(parsedDate);

  return formattedDate;
}

String formatTime(String inputDate) {
  inputDate = formatMonth('06-SEP-23 01.44.37.453904 PM');

  final parsedDate = DateFormat("dd-MMM-yy hh.mm.ss.SSSSSS a").parse(inputDate);

  // Format the time as "HH:mm"
  final formattedTime = DateFormat("HH:mm").format(parsedDate);

  return formattedTime;
}

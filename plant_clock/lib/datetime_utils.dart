

import 'package:intl/intl.dart';

String getTimeDigits() {
  return new DateFormat.Hm().format(new DateTime.now()).replaceAll(":", "");
}

bool isNight() {
  return int.parse(getTimeDigits().substring(0, 2)) >= 12;
}
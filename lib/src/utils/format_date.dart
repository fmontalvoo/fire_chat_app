import 'package:intl/intl.dart';

class FormatDate {
  static getDateFormat(time) {
    return DateFormat('kk:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(time)));
  }
}

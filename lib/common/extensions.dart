import 'package:intl/intl.dart';

extension AppDateTimeExtension on DateTime {
  String toAppStringDayMonth() {
      return DateFormat("dd.MM").format(this);
  }

  String toAppStringYearMonthDay() {
    return DateFormat("yyyy.MM.dd").format(this);
  }

  String toAppStringYearMonthDayWithTime() {
    return DateFormat("yyyy.MM.dd HH:mm:ss").format(this);
  }
}

extension AppStringExtension on String{
  String truncateTo(int length){
    if(length>this.length){
      return this;
    }
    final index = substring(0,length-2).lastIndexOf(" ");
    return "${substring(0, index-1)}...";
  }
}
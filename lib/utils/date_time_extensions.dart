extension DateTimeExtensions on DateTime {
  // Convert DateTime date to String date on "dd-mm-yyyy" format
  String toDdMmYyyy() {
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();
    return '$day-$month-$year';
  }

  // Convert DateTime time to String time on "HH:MM" format
  String to24H() {
    String time24H;
    final int h = hour;
    final int m = minute;

    final String hStr = h.toString().padLeft(2, '0');
    final String mStr = m.toString().padLeft(2, '0');

    time24H = "$hStr:$mStr";

    return time24H;
  }

  // Convert DateTime time to String time on "H:MM XM" format
  String to12H() {
    String time12H;
    final int h = hour;
    final int m = minute;
    final String mStr = m.toString().padLeft(2, '0');

    switch (h) {
      case 0:
        time12H = '12:$mStr AM';
        break;
      case >= 1 && <= 11:
        time12H = '$h:$mStr AM';
        break;
      case 12:
        time12H = '12:$mStr PM';
        break;
      case >= 13 && <= 23:
        time12H = '${h - 12}:$mStr PM';
        break;
      default:
        time12H = "Invalid time input";
    }

    return time12H;
  }
}

String getCurrentMonth() {
  final now = DateTime.now();
  final monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return monthNames[now.month - 1];
}

String getCurrentSeason() {
  DateTime now = DateTime.now();
  int month = now.month;

  if (month >= 3 && month <= 6) {
    return 'Summer';
  } else if (month >= 7 && month <= 9) {
    return 'Monsoon';
  } else if (month >= 10 && month <= 11) {
    return 'Autumn';
  } else {
    return 'Winter';
  }
}

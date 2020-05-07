import 'JSONModels/Schedule.dart';

bool concurrent(Activity a1, Activity a2) {
  return a1.startTime.isAtSameMomentAs(a2.startTime);
}

String getDate(date) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(5, 7));
  int day = int.parse(date.substring(8, 10));

  Map<int,String> months = {
    1:'January',
    2:'February',
    3:'March',
    4:'April',
    5:'May',
    6:'June',
    7:'July',
    8:'August',
    9:'September',
    10:'October',
    11:'November',
    12:'December',
  };

  return '${months[month]} $day, $year';
}

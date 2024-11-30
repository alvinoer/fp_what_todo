// models/activity.dart
class Activity {
  String name;
  String time;
  String details;
  String note;
  Datetime? reminder;

  Activity({
    required this.name,
    required this.time,
    required this.details,
    required this.note,
    this.reminder,
  });
}

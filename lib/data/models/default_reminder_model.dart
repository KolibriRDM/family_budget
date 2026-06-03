class DefaultReminderModel {
  DefaultReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isRecurring,
  });
  int id;
  String title;
  String description;
  DateTime date;
  bool isRecurring;
}

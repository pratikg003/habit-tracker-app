class Habit {
  final String id;
  final String title;
  bool isDone;

  Habit({
    required this.id,
    required this.title,
    this.isDone = false
  });
}
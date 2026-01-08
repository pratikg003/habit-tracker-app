// import 'package:flutter/foundation.dart';

class Habit {
  final String id;
  String title;
  bool isDone;
  DateTime? lastCompletedDate;
  int streak;

  Habit({
    required this.id,
    required this.title,
    this.isDone = false,
    this.lastCompletedDate,
    this.streak = 0,
  });

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'title': title,
      'isDone': isDone,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'streak' : streak
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json){
    return Habit(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
      lastCompletedDate: json['lastCompletedDate'] != null ? DateTime.parse(json['lastCompletedDate']) : null,
      streak: json['streak']??0
    );
  }
}
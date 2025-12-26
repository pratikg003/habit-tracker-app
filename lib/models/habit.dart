// import 'package:flutter/foundation.dart';

class Habit {
  final String id;
  String title;
  bool isDone;

  Habit({
    required this.id,
    required this.title,
    this.isDone = false
  });

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'title': title,
      'isDone': isDone
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json){
    return Habit(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone']
    );
  }
}
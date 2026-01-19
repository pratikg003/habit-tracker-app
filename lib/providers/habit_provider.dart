import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedHabits = prefs.getStringList('habits');

    if (savedHabits == null) return;

    _habits = savedHabits
        .map((habitSring) => Habit.fromJson(jsonDecode(habitSring)))
        .toList();
        
    resetHabitsIfNewDay();
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitList = _habits.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('habits', habitList);
  }

  void addHabit(String title) {
    _habits.add(Habit(id: DateTime.now().toIso8601String(), title: title));
    _saveHabits();
    notifyListeners();
  }

  void deleteHabit(int index) {
    _habits.removeAt(index);
    _saveHabits();
    notifyListeners();
  }

  void editHabit(int index, String newTitle) {
    _habits[index].title = newTitle;
    _saveHabits();
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isYesterday(DateTime a, DateTime b) {
    final yesterday = DateTime(b.year, b.month, b.day - 1);
    return a.year == yesterday.year &&
        a.month == yesterday.month &&
        a.day == yesterday.day;
  }

  void resetHabitsIfNewDay() {
    final today = DateTime.now();
    bool changed = false;

    for (final habit in _habits) {
      if (habit.lastCompletedDate == null) continue;

      if (!_isSameDay(habit.lastCompletedDate!, today)) {
        habit.isDone = false;

        if (!_isYesterday(habit.lastCompletedDate!, today)) {
          habit.streak = 0;
        }

        changed = true;
      }
    }

    if (changed) {
      _saveHabits();
      notifyListeners();
    }
  }
  void toggleHabit(int index) {
    final habit = _habits[index];
      final now = DateTime.now();

      if (!habit.isDone) {
        // MARK AS DONE (CHECK)

        if (habit.lastCompletedDate != null) {
          if (_isSameDay(habit.lastCompletedDate!, now)) {
            // same day re-check after undo
            habit.streak += 1;
          } else if (_isYesterday(habit.lastCompletedDate!, now)) {
            habit.streak += 1;
          } else {
            habit.streak = 1;
          }
        } else {
          habit.streak = 1;
        }

        habit.isDone = true;
        habit.lastCompletedDate = now;
      } else {
        // UNCHECK TODAY
        habit.isDone = false;

        if (habit.lastCompletedDate != null &&
            _isSameDay(habit.lastCompletedDate!, now)) {
          habit.streak = habit.streak > 0 ? habit.streak - 1 : 0;
        }
      }
    
    _saveHabits();
    notifyListeners();
  }
}

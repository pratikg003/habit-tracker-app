import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:habit_tracker_app/widgets/add_habit_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker_app/widgets/habit_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Habit> habits = [];

  final TextEditingController _controller = TextEditingController();

  void _addHabit() {
    // print('ADD HABIT CALLED');
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      habits.add(Habit(id: DateTime.now().toString(), title: text));
    });
    _saveHabits();

    _controller.clear();

    FocusScope.of(context).unfocus();
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
    _saveHabits();
  }

  void _editHabit(int index) {
    TextEditingController editController = TextEditingController(
      text: habits[index].title,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
          title: Text(
            'Edit Habit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: editController,
            autofocus: true,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isEmpty) return;
                setState(() {
                  habits[index].title = editController.text.trim();
                });
                _saveHabits();
                Navigator.pop(context); // close dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    FocusScope.of(context).unfocus();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final habitList = habits
        .map((habit) => jsonEncode(habit.toJson()))
        .toList();

    await prefs.setStringList('habits', habitList);
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedHabits = prefs.getStringList('habits');

    if (savedHabits == null) return;

    setState(() {
      habits = savedHabits
          .map((habitString) => Habit.fromJson(jsonDecode(habitString)))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      drawer: Drawer(
        backgroundColor: Colors.purple[100],
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple[200]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HABIT\nTRACKER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Welcome, User',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'S E T T I N G S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text(
                'A B O U T',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 4,
              color: Colors.purple[200],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),

                    const Text(
                      "Today's Tasks",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const Icon(Icons.person, color: Colors.white, size: 32),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: habits.isEmpty ? _buildEmptyList() : _buildHabitList(),
            ),

            AddHabitBar(
              controller: _controller,
              onAdd: _addHabit,
            ),
          ],
        ),
      ),
    );
  }

  Center _buildEmptyList() {
    return Center(
      child: Text(
        'No Habits yet! Add a new Habit.',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
    );
  }

  ListView _buildHabitList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return HabitTile(
          habit: habit,
          onToggle: () {
            setState(() {
              habit.isDone = !habit.isDone;
            });
            _saveHabits();
          },
          onDelete: () {
            _deleteHabit(index);
          },
          onEdit: () {
            _editHabit(index);
          },
        );
      },
    );
  }
}

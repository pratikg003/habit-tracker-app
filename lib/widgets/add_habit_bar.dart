import 'package:flutter/material.dart';

class AddHabitBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const AddHabitBar({super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.purple[200]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add a new habit',
                hintStyle: const TextStyle(color: Colors.purple),
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.purple),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            child: const Icon(Icons.add, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}

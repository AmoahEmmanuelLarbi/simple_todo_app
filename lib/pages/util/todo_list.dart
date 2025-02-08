import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  // variables
  final String taskName;
  final bool taskCompleted;
  final Function(bool?) checkboxOnTap;
  // delete a task
  final VoidCallback deleteTask;

  const TodoList(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.checkboxOnTap,
      required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey)),
        child:
            // change from Row widget to ListTile widget
            ListTile(
          //children: [
          // checkbox
          leading: Checkbox(
            value: taskCompleted,
            onChanged: checkboxOnTap,
            activeColor: Colors.blueAccent,
          ),
          title: Text(
            taskName,
            style: TextStyle(
              color: Colors.black,
              // strikethrough text if checkbox is checked (task is completed)
              decoration: taskCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.black,
              decorationThickness: 2,
              decorationStyle: TextDecorationStyle.solid,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: IconButton(
            onPressed: deleteTask,
            icon: const Icon(Icons.delete),
            color: Colors.red.shade400,
          ),
          //],
        ),
      ),
    );
  }
}

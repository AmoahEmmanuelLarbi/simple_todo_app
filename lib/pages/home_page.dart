import 'package:flutter/material.dart';
import 'package:my_todo_app/pages/util/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _todoList = [
    ['Read a book', false],
    ['Workout', false],
    ['Do something new', false],
    ['Code', true],
    ['Listen to a podcast', false]
  ];

// create a global form key
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
// function to change state of checkbox
  void toggleTaskCompletion(bool value, int index) {
    // change state of checkbox when clicked
    setState(() {
      _todoList[index][1] = !_todoList[index][1];
    });

    // print task if completed
    if (_todoList[index][1]) {
      // ignore: avoid_print
      print('${_todoList[index][0]} is completed');
      final snackBar = SnackBar(
        content: const Text('Task Completed'),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // make task as uncompleted when user click on "UNDO" button
              setState(() {
                _todoList[index][1] = !_todoList[index][1];
              });
              // ignore: avoid_print
              print('${_todoList[index][0]} is maked uncompleted');
            }),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // function to add a task
  void addTask() {
    // validate Textfield (check if Textfield is not empty)
    if (taskController.text.isNotEmpty) {
      setState(() {
        _todoList.add([taskController.text, false]);
        // clear textfield
        taskController.clear();
        // show snackbar
        final snackBar = SnackBar(
          content: const Text('New task added'),
          action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
          backgroundColor: Colors.blue,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  // function to delete a task
  void deleteTask(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  // display dialog to confirm task deletion
  void _showDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Delete Task')),
            content: const SizedBox(
              height: 80, // change to fit device screen
              width: 120, // change to fit device screen
              child: Center(
                child: Text(
                  'Do you want to delete this task?',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
            actions: [
              // cancel button
              OutlinedButton(
                  onPressed: () {
                    // pop alert dialog
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontFamily: 'Poppins'),
                  )),

              // space
              const SizedBox(width: 4),
              // delete button
              OutlinedButton(
                  onPressed: () {
                    // delete task
                    deleteTask(index);

                    // pop alert dialog after deletion
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ))
            ],
          );
        });
  }

  // a function to show an alert dialog box
  void _openDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Add new task')),
            content: SizedBox(
              width: 300,
              //height: 100,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: taskController,
                  expands: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)
                        //borderRadius: BorderRadius.circular(45),
                        ),
                    hintText: 'Add a task',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t add an empty task';
                    }
                    return null;
                  },
                ),
              ),
            ),
            actions: [
              // cancel
              OutlinedButton(
                onPressed: () {
                  // clear text enter into textfield
                  taskController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              // add task
              OutlinedButton(
                onPressed: () {
                  // add new task
                  if (_formKey.currentState!.validate()) {
                    addTask();
                    // clear alert dialog from the screen
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add Task'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Simple ToDo',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              return TodoList(
                taskName: _todoList[index][0],
                taskCompleted: _todoList[index][1],
                checkboxOnTap: (value) {
                  toggleTaskCompletion(value!, index);
                },
                deleteTask: () {
                  _showDialog(index);
                },
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              //addTask();
              _openDialog();
            },
            elevation: 10,
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            mini: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/task_services.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      home: TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final user = "testUser";

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await TaskService.fetchTasks(user);
    setState(() {});
  }

  Future<void> addTask() async {
    await TaskService.addTask(user, _titleController.text, _descController.text);
    _titleController.clear();
    _descController.clear();
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await TaskService.deleteTask(id);
    loadTasks();
  }

  Future<void> markAsDone(String id) async {
    await TaskService.updateTaskStatus(id, 'done');
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
                TextField(controller: _descController, decoration: InputDecoration(labelText: 'Description')),
                SizedBox(height: 8),
                ElevatedButton(onPressed: addTask, child: Text('Add Task')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) {
                final task = tasks[i];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('${task.description} • ${task.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.check), onPressed: () => markAsDone(task.id)),
                      IconButton(icon: Icon(Icons.delete), onPressed: () => deleteTask(task.id)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

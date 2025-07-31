import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/task_services.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

enum TaskFilter { all, pending, inProgress, done }

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDueDate;
  final user = "testUser";
  TaskFilter selectedFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final allTasks = await TaskService.fetchTasks(user);
    setState(() {
      tasks = allTasks.where((task) {
        switch (selectedFilter) {
          case TaskFilter.pending:
            return task.status == 'pending';
          case TaskFilter.inProgress:
            return task.status == 'in-progress';
          case TaskFilter.done:
            return task.status == 'done';
          default:
            return true;
        }
      }).toList();
    });
  }

  Future<void> addTask() async {
    if (_titleController.text.isEmpty) return;
    await TaskService.addTask(
      user,
      _titleController.text,
      _descController.text,
      dueDate: _selectedDueDate,
    );
    _titleController.clear();
    _descController.clear();
    setState(() => _selectedDueDate = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task added!'), duration: Duration(seconds: 1)),
    );
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await TaskService.deleteTask(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted!'), duration: Duration(seconds: 1)),
      );
      loadTasks();
    }
  }

  Future<void> updateStatus(String id, String status) async {
    await TaskService.updateTaskStatus(id, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task updated!'), duration: Duration(seconds: 1)),
    );
    loadTasks();
  }

  Future<void> clearCompletedTasks() async {
    final completed = tasks.where((t) => t.status == 'done').toList();
    if (completed.isEmpty) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear Completed Tasks'),
        content: Text('Delete all completed tasks?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete All')),
        ],
      ),
    );
    if (confirm == true) {
      for (final t in completed) {
        await TaskService.deleteTask(t.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completed tasks cleared!'), duration: Duration(seconds: 1)),
      );
      loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadTasks,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.cleaning_services),
            onPressed: clearCompletedTasks,
            tooltip: 'Clear Completed',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add New Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _descController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        minLines: 1,
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDueDate == null
                                  ? 'No due date selected'
                                  : 'Due: ' +
                                      '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}',
                              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                            ),
                          ),
                          TextButton.icon(
                            icon: Icon(Icons.calendar_today, size: 18),
                            label: Text('Pick Due Date'),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _selectedDueDate = picked);
                              }
                            },
                          ),
                          if (_selectedDueDate != null)
                            IconButton(
                              icon: Icon(Icons.clear, size: 18),
                              onPressed: () => setState(() => _selectedDueDate = null),
                              tooltip: 'Clear Due Date',
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Task'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: addTask,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // FILTER CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterChip(
                      label: Text('All'),
                      selected: selectedFilter == TaskFilter.all,
                      onSelected: (_) {
                        setState(() => selectedFilter = TaskFilter.all);
                        loadTasks();
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('Pending'),
                      selected: selectedFilter == TaskFilter.pending,
                      onSelected: (_) {
                        setState(() => selectedFilter = TaskFilter.pending);
                        loadTasks();
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('In Progress'),
                      selected: selectedFilter == TaskFilter.inProgress,
                      onSelected: (_) {
                        setState(() => selectedFilter = TaskFilter.inProgress);
                        loadTasks();
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('Done'),
                      selected: selectedFilter == TaskFilter.done,
                      onSelected: (_) {
                        setState(() => selectedFilter = TaskFilter.done);
                        loadTasks();
                      },
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 24, thickness: 1.2),

            // TASK LIST
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: tasks.length,
                      itemBuilder: (ctx, i) {
                        final task = tasks[i];
                        Color statusColor;
                        switch (task.status) {
                          case 'done':
                            statusColor = Colors.green[400]!;
                            break;
                          case 'in-progress':
                            statusColor = Colors.orange[400]!;
                            break;
                          default:
                            statusColor = Colors.blue[300]!;
                        }
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              task.status,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          DropdownButton<String>(
                                            value: task.status,
                                            items: ['pending', 'in-progress', 'done'].map((status) {
                                              return DropdownMenuItem(
                                                value: status,
                                                child: Text(status),
                                              );
                                            }).toList(),
                                            onChanged: (newStatus) {
                                              if (newStatus != null) {
                                                updateStatus(task.id, newStatus);
                                              }
                                            },
                                            underline: SizedBox(),
                                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red[400]),
                                  onPressed: () => deleteTask(task.id),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

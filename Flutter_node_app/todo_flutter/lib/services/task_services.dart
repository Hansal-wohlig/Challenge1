import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  static const String baseUrl = 'http://localhost:5000/api'; // Use your IP in mobile

  static Future<List<Task>> fetchTasks(String user) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks?user=$user'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<void> addTask(String user, String title, String description) async {
    await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user,
        'title': title,
        'description': description,
        'status': 'pending'
      }),
    );
  }

  static Future<void> deleteTask(String id) async {
    await http.delete(Uri.parse('$baseUrl/tasks/$id'));
  }

  static Future<void> updateTaskStatus(String id, String status) async {
    await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
  }
}

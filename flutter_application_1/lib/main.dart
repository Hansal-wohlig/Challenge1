// import 'package:flutter/material.dart';

// void main() {
//   runApp(const ToDoApp());
// }

// class ToDoApp extends StatelessWidget {
//   const ToDoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To-Do List',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const ToDoHomePage(),
//     );
//   }
// }

// class ToDoHomePage extends StatefulWidget {
//   const ToDoHomePage({super.key});

//   @override
//   State<ToDoHomePage> createState() => _ToDoHomePageState();
// }

// class _ToDoHomePageState extends State<ToDoHomePage> {
//   final TextEditingController _controller = TextEditingController();
//   final List<String> _todo = [];
//   final List<String> _inProgress = [];
//   final List<String> _done = [];

//   void _addTodo() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         _todo.add(_controller.text);
//         _controller.clear();
//       });
//     }
//   }

//   void _moveTask(String task, List<String> from, List<String> to) {
//     setState(() {
//       from.remove(task);
//       to.add(task);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kanban Board'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter a task',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) => _addTodo(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _addTodo,
//                   child: const Text('Add'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildKanbanColumn('To Do', _todo, (task) {
//                     _moveTask(task, _todo, _inProgress);
//                   }, Colors.blue[100]!, acceptFrom: [_inProgress, _done]),
//                   const SizedBox(width: 8),
//                   _buildKanbanColumn('In Progress', _inProgress, (task) {
//                     _moveTask(task, _inProgress, _done);
//                   }, Colors.orange[100]!, acceptFrom: [_todo, _done]),
//                   const SizedBox(width: 8),
//                   _buildKanbanColumn('Done', _done, null, Colors.green[100]!, acceptFrom: [_inProgress, _todo]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildKanbanColumn(String title, List<String> tasks, void Function(String)? onMove, Color color, {required List<List<String>> acceptFrom}) {
//     return Expanded(
//       child: DragTarget<String>(
//         onWillAccept: (data) => true,
//         onAccept: (data) {
//           for (var list in acceptFrom) {
//             if (list.contains(data)) {
//               setState(() {
//                 list.remove(data);
//                 tasks.add(data);
//               });
//               break;
//             }
//           }
//         },
//         builder: (context, candidateData, rejectedData) => Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = tasks[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Draggable<String>(
//                         data: task,
//                         feedback: Material(
//                           color: Colors.transparent,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: color.withOpacity(0.7),
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: Text(task, style: const TextStyle(fontSize: 16)),
//                           ),
//                         ),
//                         childWhenDragging: Opacity(
//                           opacity: 0.5,
//                           child: _kanbanTaskTile(task, onMove),
//                         ),
//                         child: _kanbanTaskTile(task, onMove),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _kanbanTaskTile(String task, void Function(String)? onMove) {
//     return ListTile(
//       title: Text(task),
//       trailing: onMove != null
//           ? IconButton(
//               icon: const Icon(Icons.arrow_forward),
//               onPressed: () => onMove(task),
//             )
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('my first app'),
          centerTitle: true,
          backgroundColor: Colors.red[600]
      ),
      body: Container(
          margin: EdgeInsets.all(40.0),
          padding: EdgeInsets.all(30.0),
          color: Colors.grey[400],
          child: Text('hey, ninjas!'),
 ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {print("Clicked ")},
        backgroundColor: Colors.red[600],
        child: Text('click'),
      ),
    );
  }
}

// snippets for padding & margin

//  Container(
//    margin: EdgeInsets.all(40.0),
//    padding: EdgeInsets.all(30.0),
//    color: Colors.grey[400],
//    child: Text('hey, ninjas!'),
//  ),
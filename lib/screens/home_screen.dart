import 'package:flutter/material.dart';
import '../repository/task_repository.dart';
import 'add_task_screen.dart';
import '../models/task.dart';

class HomeScreen extends StatelessWidget {
  final repo = TaskRepository();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: StreamBuilder<List<Task>>(
        stream: repo.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;

          return ListView(
            children:
                tasks.map((task) {
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => repo.deleteTask(task.id),
                    ),
                  );
                }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

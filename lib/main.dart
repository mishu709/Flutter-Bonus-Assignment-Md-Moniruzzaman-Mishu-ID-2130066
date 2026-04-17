import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    const MaterialApp(home: TaskScreen(), debugShowCheckedModeBanner: false),
  );
}

// --- DATA MODEL ---
class Task {
  final String? id;
  final String title;
  final String description;

  Task({this.id, required this.title, required this.description});

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'createdAt': FieldValue.serverTimestamp(),
  };
}

// --- UI SCREEN ---
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final CollectionReference _tasks = FirebaseFirestore.instance.collection(
    'tasks',
  );

  void _addTask() {
    if (titleController.text.isNotEmpty) {
      _tasks.add(
        Task(
          title: titleController.text,
          description: descController.text,
        ).toMap(),
      );
      titleController.clear();
      descController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Tasks"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: _tasks.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Task task = Task.fromFirestore(snapshot.data!.docs[index]);
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _tasks.doc(task.id).delete(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("New Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: _addTask, child: const Text("Save")),
            ],
          ),
    );
  }
}

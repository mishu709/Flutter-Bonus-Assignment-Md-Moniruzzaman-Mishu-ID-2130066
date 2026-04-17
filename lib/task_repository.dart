import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class TaskRepository {
  final CollectionReference _db = FirebaseFirestore.instance.collection(
    'tasks',
  );

  // Add a new task
  Future<void> addTask(Task task) async {
    await _db.add(task.toFirestore());
  }

  // Delete a task by ID
  Future<void> deleteTask(String id) async {
    await _db.doc(id).delete();
  }

  // Real-time stream of tasks
  Stream<List<Task>> getTasksStream() {
    return _db.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addTask(String title, String description) async {
    await _db.collection('tasks').add({
      'title': title,
      'description': description,
    });
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }

  Stream<List<Task>> getTasks() {
    return _db
        .collection('tasks')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Task.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }
}

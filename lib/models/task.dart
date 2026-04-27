class Task {
  String id;
  String title;
  String description;

  Task({required this.id, required this.title, required this.description});

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description};
  }
}

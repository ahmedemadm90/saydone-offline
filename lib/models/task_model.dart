class Task {
  final int? id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? transcription;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.status = 'pending',
    this.priority = 'medium',
    this.transcription,
    required this.createdAt,
  });

  bool get isCompleted => status == 'completed';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'transcription': transcription,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      transcription: map['transcription'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? transcription,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      transcription: transcription ?? this.transcription,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

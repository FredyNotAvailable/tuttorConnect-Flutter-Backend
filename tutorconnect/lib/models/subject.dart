class Subject {
  final String id;
  final String name;

  Subject({
    required this.id,
    required this.name,
  });

  factory Subject.fromMap(Map<String, dynamic> map, String documentId) {
    return Subject(
      id: documentId,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

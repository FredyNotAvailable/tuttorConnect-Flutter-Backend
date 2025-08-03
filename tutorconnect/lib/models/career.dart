class Career {
  final String id;
  final String name;

  Career({
    required this.id,
    required this.name,
  });

  factory Career.fromMap(Map<String, dynamic> map, String documentId) {
    return Career(
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

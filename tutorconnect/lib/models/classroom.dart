enum ClassroomType {
  lab,
  classroom,
}

class Classroom {
  final String id;
  final bool available;
  final String name;
  final ClassroomType type;

  Classroom({
    required this.id,
    required this.available,
    required this.name,
    required this.type,
  });

  factory Classroom.fromMap(Map<String, dynamic> map, String documentId) {
    return Classroom(
      id: documentId,
      available: map['available'] ?? false,
      name: map['name'] ?? '',
      type: _stringToClassroomType(map['type'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'available': available,
      'name': name,
      'type': _classroomTypeToString(type),
    };
  }

  static ClassroomType _stringToClassroomType(String type) {
    switch (type.toLowerCase()) {
      case 'lab':
        return ClassroomType.lab;
      case 'classroom':
        return ClassroomType.classroom;
      default:
        return ClassroomType.classroom; // Valor por defecto
    }
  }

  static String _classroomTypeToString(ClassroomType type) {
    switch (type) {
      case ClassroomType.lab:
        return 'lab';
      case ClassroomType.classroom:
        return 'classroom';
    }
  }
}

extension ClassroomTypeExtension on ClassroomType {
  String get nombreEnEspanol {
    switch (this) {
      case ClassroomType.lab:
        return 'Laboratorio';
      case ClassroomType.classroom:
        return 'Aula';
    }
  }
}
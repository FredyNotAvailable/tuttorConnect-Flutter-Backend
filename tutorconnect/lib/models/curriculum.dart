import 'package:cloud_firestore/cloud_firestore.dart';

class Curriculum {
  final String id;
  final String careerId;
  final DateTime createdAt;
  final int curriculumYear;
  final int cycles;
  final bool isActive;
  final Map<String, List<String>> subjectsByCycle;

  Curriculum({
    required this.id,
    required this.careerId,
    required this.createdAt,
    required this.curriculumYear,
    required this.cycles,
    required this.isActive,
    required this.subjectsByCycle,
  });

  factory Curriculum.fromMap(Map<String, dynamic> map, String documentId) {
    // Parse Map<String, dynamic> subjectsByCycle to Map<String, List<String>>
    final Map<String, dynamic> rawMap = map['subjectsByCycle'] ?? {};
    final subjectsByCycle = rawMap.map<String, List<String>>((key, value) {
      List<String> list = [];
      if (value is List) {
        list = value.map((e) => e.toString()).toList();
      }
      return MapEntry(key, list);
    });

    return Curriculum(
      id: documentId,
      careerId: map['careerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      curriculumYear: map['curriculumYear'] ?? 0,
      cycles: map['cycles'] ?? 0,
      isActive: map['isActive'] ?? false,
      subjectsByCycle: subjectsByCycle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'careerId': careerId,
      'createdAt': createdAt,
      'curriculumYear': curriculumYear,
      'cycles': cycles,
      'isActive': isActive,
      'subjectsByCycle': subjectsByCycle,
    };
  }
}

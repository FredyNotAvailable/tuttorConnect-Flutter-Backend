import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherPlan {
  final String id;
  final String careerId;
  final DateTime createdAt;
  final bool isActive;
  final Map<String, List<String>> subjectsByCycle;
  final String teacherId;

  TeacherPlan({
    required this.id,
    required this.careerId,
    required this.createdAt,
    required this.isActive,
    required this.subjectsByCycle,
    required this.teacherId,
  });

  factory TeacherPlan.fromMap(Map<String, dynamic> map, String documentId) {
    final Map<String, dynamic> rawMap = map['subjectsByCycle'] ?? {};
    final subjectsByCycle = rawMap.map<String, List<String>>((key, value) {
      List<String> list = [];
      if (value is List) {
        list = value.map((e) => e.toString()).toList();
      }
      return MapEntry(key, list);
    });

    return TeacherPlan(
      id: documentId,
      careerId: map['careerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? false,
      subjectsByCycle: subjectsByCycle,
      teacherId: map['teacherId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'careerId': careerId,
      'createdAt': createdAt,
      'isActive': isActive,
      'subjectsByCycle': subjectsByCycle,
      'teacherId': teacherId,
    };
  }
}

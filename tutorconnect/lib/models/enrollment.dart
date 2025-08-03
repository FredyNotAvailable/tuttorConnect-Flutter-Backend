import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String id;
  final String careerId;
  final int cycle;
  final bool isActive;
  final String studentId;
  final DateTime createdAt;

  Enrollment({
    required this.id,
    required this.careerId,
    required this.cycle,
    required this.isActive,
    required this.studentId,
    required this.createdAt,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map, String documentId) {
    return Enrollment(
      id: documentId,
      careerId: map['careerId'] ?? '',
      cycle: map['cycle'] ?? 0,
      isActive: map['isActive'] ?? false,
      studentId: map['studentId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'careerId': careerId,
      'cycle': cycle,
      'isActive': isActive,
      'studentId': studentId,
      'createdAt': createdAt,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum SubjectEnrollmentStatus {
  inProgress,
  failed,
  passed,
}

class SubjectEnrollment {
  final String id;
  final DateTime enrollmentDate;
  final SubjectEnrollmentStatus status;
  final String studentId;
  final String subjectId;
  final String term; // ejemplo: "2025-A"

  SubjectEnrollment({
    required this.id,
    required this.enrollmentDate,
    required this.status,
    required this.studentId,
    required this.subjectId,
    required this.term,
  });

  factory SubjectEnrollment.fromMap(Map<String, dynamic> map, String documentId) {
    return SubjectEnrollment(
      id: documentId,
      enrollmentDate: (map['enrollmentDate'] as Timestamp).toDate(),
      status: _stringToStatus(map['status'] ?? 'inProgress'),
      studentId: map['studentId'] ?? '',
      subjectId: map['subjectId'] ?? '',
      term: map['term'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enrollmentDate': enrollmentDate,
      'status': _statusToString(status),
      'studentId': studentId,
      'subjectId': subjectId,
      'term': term,
    };
  }

  static SubjectEnrollmentStatus _stringToStatus(String status) {
    switch (status) {
      case 'passed':
        return SubjectEnrollmentStatus.passed;
      case 'failed':
        return SubjectEnrollmentStatus.failed;
      case 'inProgress':
      default:
        return SubjectEnrollmentStatus.inProgress;
    }
  }

  static String _statusToString(SubjectEnrollmentStatus status) {
    switch (status) {
      case SubjectEnrollmentStatus.passed:
        return 'passed';
      case SubjectEnrollmentStatus.failed:
        return 'failed';
      case SubjectEnrollmentStatus.inProgress:
        return 'inProgress';
    }
  }
}

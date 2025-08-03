import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/models/tutoring_request.dart';

enum AttendanceStatus {
  present,
  absent,
}

class TutoringAttendance {
  final String id;
  final DateTime date;
  final AttendanceStatus status;
  final String studentId;
  final String tutoriaId;

  TutoringAttendance({
    required this.id,
    required this.date,
    required this.status,
    required this.studentId,
    required this.tutoriaId,
  });

  factory TutoringAttendance.fromMap(Map<String, dynamic> map, String documentId) {
    return TutoringAttendance(
      id: documentId,
      date: (map['date'] as Timestamp).toDate(),
      status: _stringToStatus(map['status'] ?? 'absent'),
      studentId: map['studentId'] ?? '',
      tutoriaId: map['tutoriaId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'status': _statusToString(status),
      'studentId': studentId,
      'tutoriaId': tutoriaId,
    };
  }

  static AttendanceStatus _stringToStatus(String status) {
    switch (status) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
      default:
        return AttendanceStatus.absent;
    }
  }

  static String _statusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
    }
  }

  static String statusToStringSpanish(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Presente';
      case AttendanceStatus.absent:
        return 'Ausente';
    }
  }
}

class TutoringRequestUtils {
  static String statusToSpanish(TutoringRequestStatus status) {
    switch (status) {
      case TutoringRequestStatus.pending:
        return 'Pendiente';
      case TutoringRequestStatus.accepted:
        return 'Aceptado';
      case TutoringRequestStatus.rejected:
        return 'Rechazado';
      default:
        return status.name;
    }
  }
}
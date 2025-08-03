import 'package:cloud_firestore/cloud_firestore.dart';

enum TutoringStatus {
  active,
  finished,
  canceled,
}

class Tutoring {
  final String id;               
  final String classroomId;      
  final DateTime createdAt;      
  final DateTime date;           
  final String startTime;        
  final String endTime;          
  final String notes;            
  final TutoringStatus status;   
  final List<String> tutoringRequestIds; 
  final String subjectId;        
  final String teacherId;        
  final String topic;            
  final List<String> studentIds;    // <-- agregado

  Tutoring({
    required this.id,
    required this.classroomId,
    required this.createdAt,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.status,
    required this.tutoringRequestIds,
    required this.subjectId,
    required this.teacherId,
    required this.topic,
    required this.studentIds,        // <-- agregado
  });

  factory Tutoring.fromMap(Map<String, dynamic> map, String documentId) {
    return Tutoring(
      id: documentId,
      classroomId: map['classroomId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      date: (map['date'] as Timestamp).toDate(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      notes: map['notes'] ?? '',
      status: _stringToStatus(map['status'] ?? 'active'),
      tutoringRequestIds: List<String>.from(map['tutoringRequestIds'] ?? []),
      subjectId: map['subjectId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      topic: map['topic'] ?? '',
      studentIds: List<String>.from(map['studentIds'] ?? []),   // <-- agregado
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'createdAt': createdAt,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
      'status': _statusToString(status),
      'tutoringRequestIds': tutoringRequestIds,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'topic': topic,
      'studentIds': studentIds,           // <-- agregado
    };
  }

  static TutoringStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TutoringStatus.active;
      case 'finished':
        return TutoringStatus.finished;
      case 'canceled':
        return TutoringStatus.canceled;
      default:
        return TutoringStatus.active;
    }
  }

  static String _statusToString(TutoringStatus status) {
    return status.toString().split('.').last;
  }

  Tutoring copyWith({
    String? id,
    String? classroomId,
    DateTime? createdAt,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? notes,
    TutoringStatus? status,
    List<String>? tutoringRequestIds,
    String? subjectId,
    String? teacherId,
    String? topic,
    List<String>? studentIds,            // <-- agregado
  }) {
    return Tutoring(
      id: id ?? this.id,
      classroomId: classroomId ?? this.classroomId,
      createdAt: createdAt ?? this.createdAt,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      tutoringRequestIds: tutoringRequestIds ?? this.tutoringRequestIds,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      topic: topic ?? this.topic,
      studentIds: studentIds ?? this.studentIds,    // <-- agregado
    );
  }
}

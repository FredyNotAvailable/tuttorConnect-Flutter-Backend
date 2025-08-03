import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  newTutoring,
  tutoringRequest,
  reminder,
  cancellation,
  // agrega más tipos si es necesario
}

class NotificationModel {
  final String id;
  final String message;
  final bool read;
  final DateTime sentAt;
  final String title;
  final String? tutoringId;
  final NotificationType type;
  final String userId;

  NotificationModel({
    required this.id,
    required this.message,
    required this.read,
    required this.sentAt,
    required this.title,
    this.tutoringId,
    required this.type,
    required this.userId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NotificationModel(
      id: documentId,
      message: map['message'] ?? '',
      read: map['read'] ?? false,
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      title: map['title'] ?? '',
      tutoringId: map['tutoringId'],
      type: _stringToNotificationType(map['type'] ?? ''),
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'read': read,
      'sentAt': sentAt,
      'title': title,
      'tutoringId': tutoringId,
      'type': _notificationTypeToString(type),
      'userId': userId,
    };
  }

  static NotificationType _stringToNotificationType(String type) {
    switch (type) {
      case 'new_tutoring':
        return NotificationType.newTutoring;
      case 'tutoring_request':
        return NotificationType.tutoringRequest;
      case 'reminder':
        return NotificationType.reminder;
      case 'cancellation':
        return NotificationType.cancellation;
      default:
        return NotificationType.newTutoring; // valor por defecto
    }
  }

  static String _notificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.newTutoring:
        return 'new_tutoring';
      case NotificationType.tutoringRequest:
        return 'tutoring_request';
      case NotificationType.reminder:
        return 'reminder';
      case NotificationType.cancellation:
        return 'cancellation';
    }
  }
}

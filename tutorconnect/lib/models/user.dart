import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart'; // asumes que aquí está UserRole

class User {
  final String id;
  final String email;
  final String fullname;
  final UserRole role;
  final String? fcmToken;
  final String? photoUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.fullname,
    required this.role,
    this.fcmToken,
    this.photoUrl,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    Timestamp? ts = map['createdAt'] as Timestamp?;

    return User(
      id: documentId,
      email: map['email'] ?? '',
      fullname: map['fullname'] ?? '',
      role: UserRoleExtension.fromString(map['role'] ?? 'student'),
      fcmToken: map['fcmToken'],
      photoUrl: map['photoUrl'],
      createdAt: ts != null ? ts.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullname': fullname,
      'role': role.toShortString(),
      'fcmToken': fcmToken,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullname,
    UserRole? role,
    String? fcmToken,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}

import 'package:tutorconnect/data/firebase_subject_enrollment_datasource.dart';

import '../../models/subject_enrollment.dart';
import 'subject_enrollment_repository.dart';

class SubjectEnrollmentRepositoryImpl implements SubjectEnrollmentRepository {
  final FirebaseSubjectEnrollmentDataSource dataSource;

  SubjectEnrollmentRepositoryImpl({required this.dataSource});

  @override
  Future<SubjectEnrollment?> getSubjectEnrollmentById(String id) {
    return dataSource.getSubjectEnrollmentById(id);
  }

  @override
  Future<List<SubjectEnrollment>> getAllSubjectEnrollments() {
    return dataSource.getAllSubjectEnrollments();
  }

  @override
  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStudentId(String studentId) {
    return dataSource.getSubjectEnrollmentsByStudentId(studentId);
  }

  @override
  Future<List<SubjectEnrollment>> getSubjectEnrollmentsBySubjectId(String subjectId) {
    return dataSource.getSubjectEnrollmentsBySubjectId(subjectId);
  }

  @override
  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStatus(String subjectId) {
    return dataSource.getSubjectEnrollmentsByStatus(subjectId);
  }
}

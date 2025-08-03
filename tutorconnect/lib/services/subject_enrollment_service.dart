import 'package:tutorconnect/repositories/subject_enrollment/subject_enrollment_repository.dart';
import '../models/subject_enrollment.dart';

class SubjectEnrollmentService {
  final SubjectEnrollmentRepository _repository;

  SubjectEnrollmentService(this._repository);

  Future<SubjectEnrollment?> getSubjectEnrollmentById(String id) async {
    return await _repository.getSubjectEnrollmentById(id);
  }

  Future<List<SubjectEnrollment>> getAllSubjectEnrollments() async {
    return await _repository.getAllSubjectEnrollments();
  }

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStudentId(String studentId) async {
    return await _repository.getSubjectEnrollmentsByStudentId(studentId);
  }

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsBySubjectId(String subjectId) async {
    return await _repository.getSubjectEnrollmentsBySubjectId(subjectId);
  }

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStatus(String subjectId) async {
    return await _repository.getSubjectEnrollmentsByStatus(subjectId);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_subject_enrollment_datasource.dart';
import 'package:tutorconnect/models/subject_enrollment.dart';
import 'package:tutorconnect/repositories/subject_enrollment/subject_enrollment_repository.dart';
import 'package:tutorconnect/repositories/subject_enrollment/subject_enrollment_repository_impl.dart';
import 'package:tutorconnect/services/subject_enrollment_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseSubjectEnrollmentDataSourceProvider = Provider<FirebaseSubjectEnrollmentDataSource>((ref) {
  return FirebaseSubjectEnrollmentDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final subjectEnrollmentRepositoryProvider = Provider<SubjectEnrollmentRepository>((ref) {
  final dataSource = ref.read(firebaseSubjectEnrollmentDataSourceProvider);
  return SubjectEnrollmentRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final subjectEnrollmentServiceProvider = Provider<SubjectEnrollmentService>((ref) {
  final repository = ref.read(subjectEnrollmentRepositoryProvider);
  return SubjectEnrollmentService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class SubjectEnrollmentNotifier extends StateNotifier<List<SubjectEnrollment>> {
  final SubjectEnrollmentService _service;

  SubjectEnrollmentNotifier(this._service) : super([]) {
    loadEnrollments();
  }

  Future<void> loadEnrollments() async {
    final enrollments = await _service.getAllSubjectEnrollments();
    state = enrollments;
  }

  Future<List<SubjectEnrollment>> getEnrollmentsByStudentId(String studentId) async {
    return await _service.getSubjectEnrollmentsByStudentId(studentId);
  }

  Future<List<SubjectEnrollment>> getEnrollmentsBySubjectId(String subjectId) async {
    return await _service.getSubjectEnrollmentsBySubjectId(subjectId);
  }

  Future<SubjectEnrollment?> getEnrollmentById(String id) async {
    return await _service.getSubjectEnrollmentById(id);
  }

  Future<List<SubjectEnrollment>> getEnrollmentsByStatus(String status) async {
    return await _service.getSubjectEnrollmentsByStatus(status);
  }
}

// 5. Proveedor del StateNotifier
final subjectEnrollmentProvider = StateNotifierProvider<SubjectEnrollmentNotifier, List<SubjectEnrollment>>((ref) {
  final service = ref.read(subjectEnrollmentServiceProvider);
  return SubjectEnrollmentNotifier(service);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_enrollment_datasource.dart';
import 'package:tutorconnect/models/enrollment.dart';
import 'package:tutorconnect/repositories/enrollment/enrollment_repository.dart';
import 'package:tutorconnect/repositories/enrollment/enrollment_repository_impl.dart';
import 'package:tutorconnect/services/enrollment_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseEnrollmentDataSourceProvider = Provider<FirebaseEnrollmentDataSource>((ref) {
  return FirebaseEnrollmentDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  final dataSource = ref.read(firebaseEnrollmentDataSourceProvider);
  return EnrollmentRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final enrollmentServiceProvider = Provider<EnrollmentService>((ref) {
  final repository = ref.read(enrollmentRepositoryProvider);
  return EnrollmentService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class EnrollmentNotifier extends StateNotifier<List<Enrollment>> {
  final EnrollmentService _service;

  EnrollmentNotifier(this._service) : super([]) {
    loadEnrollments();
  }

  Future<void> loadEnrollments() async {
    final enrollments = await _service.getAllEnrollments();
    state = enrollments;
  }

  Future<Enrollment?> getEnrollmentById(String id) async {
    return await _service.getEnrollmentById(id);
  }
}

// 5. Proveedor del StateNotifier
final enrollmentProvider = StateNotifierProvider<EnrollmentNotifier, List<Enrollment>>((ref) {
  final service = ref.read(enrollmentServiceProvider);
  return EnrollmentNotifier(service);
});

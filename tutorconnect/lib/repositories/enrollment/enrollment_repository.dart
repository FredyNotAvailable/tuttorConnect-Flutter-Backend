import '../../models/enrollment.dart';

abstract class EnrollmentRepository {
  Future<Enrollment?> getEnrollmentById(String id);

  Future<List<Enrollment>> getAllEnrollments();
}

import 'package:tutorconnect/repositories/enrollment/enrollment_repository.dart';
import '../models/enrollment.dart';

class EnrollmentService {
  final EnrollmentRepository _enrollmentRepository;

  EnrollmentService(this._enrollmentRepository);

  Future<Enrollment?> getEnrollmentById(String id) async {
    return await _enrollmentRepository.getEnrollmentById(id);
  }

  Future<List<Enrollment>> getAllEnrollments() async {
    return await _enrollmentRepository.getAllEnrollments();
  }
}

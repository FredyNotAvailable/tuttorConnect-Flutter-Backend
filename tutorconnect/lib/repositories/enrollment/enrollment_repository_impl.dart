import 'package:tutorconnect/data/firebase_enrollment_datasource.dart';

import '../../models/enrollment.dart';
import 'enrollment_repository.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final FirebaseEnrollmentDataSource dataSource;

  EnrollmentRepositoryImpl({required this.dataSource});

  @override
  Future<Enrollment?> getEnrollmentById(String id) {
    return dataSource.getEnrollmentById(id);
  }

  @override
  Future<List<Enrollment>> getAllEnrollments() {
    return dataSource.getAllEnrollments();
  }
}

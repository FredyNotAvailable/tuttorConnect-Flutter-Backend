import 'package:tutorconnect/data/firebase_tutoring_attendance_datasource.dart';

import '../../models/tutoring_attendance.dart';
import 'tutoring_attendance_repository.dart';

class TutoringAttendanceRepositoryImpl implements TutoringAttendanceRepository {
  final FirebaseTutoringAttendanceDataSource dataSource;

  TutoringAttendanceRepositoryImpl({required this.dataSource});

  @override
  Future<TutoringAttendance?> getAttendanceById(String id) {
    return dataSource.getAttendanceById(id);
  }

  @override
  Future<List<TutoringAttendance>> getAllAttendances() {
    return dataSource.getAllAttendances();
  }

  @override
  Future<List<TutoringAttendance>> getAttendancesByTutoriaId(String tutoriaId) {
    return dataSource.getAttendancesByTutoriaId(tutoriaId);
  }

  @override
  Future<List<TutoringAttendance>> getAttendancesByStudentId(String studentId) {
    return dataSource.getAttendancesByStudentId(studentId);
  }

  @override
  Future<void> addAttendance(TutoringAttendance attendance) {
    return dataSource.addAttendance(attendance);
  }

  @override
  Future<void> updateAttendance(TutoringAttendance attendance) {
    return dataSource.updateAttendance(attendance);
  }
}

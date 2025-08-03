import 'package:tutorconnect/repositories/tutoring_attendance/tutoring_attendance_repository.dart';
import '../models/tutoring_attendance.dart';

class TutoringAttendanceService {
  final TutoringAttendanceRepository _repository;

  TutoringAttendanceService(this._repository);

  Future<TutoringAttendance?> getAttendanceById(String id) async {
    return await _repository.getAttendanceById(id);
  }

  Future<List<TutoringAttendance>> getAllAttendances() async {
    return await _repository.getAllAttendances();
  }

  Future<List<TutoringAttendance>> getAttendancesByTutoriaId(String tutoriaId) async {
    return await _repository.getAttendancesByTutoriaId(tutoriaId);
  }

  Future<List<TutoringAttendance>> getAttendancesByStudentId(String studentId) async {
    return await _repository.getAttendancesByStudentId(studentId);
  }

  Future<void> addAttendance(TutoringAttendance attendance) async {
    await _repository.addAttendance(attendance);
  }

  Future<void> updateAttendance(TutoringAttendance attendance) async {
    await _repository.updateAttendance(attendance);
  }
}

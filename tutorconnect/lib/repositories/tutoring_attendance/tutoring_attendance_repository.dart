import '../../models/tutoring_attendance.dart';

abstract class TutoringAttendanceRepository {
  Future<TutoringAttendance?> getAttendanceById(String id);

  Future<List<TutoringAttendance>> getAllAttendances();

  Future<List<TutoringAttendance>> getAttendancesByTutoriaId(String tutoriaId);

  Future<List<TutoringAttendance>> getAttendancesByStudentId(String studentId);

  Future<void> addAttendance(TutoringAttendance attendance);

  Future<void> updateAttendance(TutoringAttendance attendance);
}

import '../../models/class_schedule.dart';

abstract class ClassScheduleRepository {
  Future<ClassSchedule?> getClassScheduleById(String id);

  Future<List<ClassSchedule>> getAllClassSchedules();

  Future<List<ClassSchedule>> getClassSchedulesByTeacherId(String teacherId);

  Future<List<ClassSchedule>> getClassSchedulesByClassroomId(String classroomId);

  // Nuevo método
  Future<List<ClassSchedule>> getClassSchedulesBySubjectId(String subjectId);
}

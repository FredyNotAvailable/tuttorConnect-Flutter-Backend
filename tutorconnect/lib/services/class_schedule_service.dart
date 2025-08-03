import 'package:tutorconnect/repositories/class_schedule/class_schedule_repository.dart';
import '../models/class_schedule.dart';

class ClassScheduleService {
  final ClassScheduleRepository _repository;

  ClassScheduleService(this._repository);

  Future<ClassSchedule?> getClassScheduleById(String id) async {
    return await _repository.getClassScheduleById(id);
  }

  Future<List<ClassSchedule>> getAllClassSchedules() async {
    return await _repository.getAllClassSchedules();
  }

  Future<List<ClassSchedule>> getClassSchedulesByTeacherId(String teacherId) async {
    return await _repository.getClassSchedulesByTeacherId(teacherId);
  }

  Future<List<ClassSchedule>> getClassSchedulesByClassroomId(String classroomId) async {
    return await _repository.getClassSchedulesByClassroomId(classroomId);
  }
  
  // Nuevo método agregado para obtener horarios por materia
  Future<List<ClassSchedule>> getClassSchedulesBySubjectId(String subjectId) async {
    return await _repository.getClassSchedulesBySubjectId(subjectId);
  }
}

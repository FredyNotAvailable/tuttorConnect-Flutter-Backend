import 'package:tutorconnect/data/firebase_class_schedule_datasource.dart';

import '../../models/class_schedule.dart';
import 'class_schedule_repository.dart';

class ClassScheduleRepositoryImpl implements ClassScheduleRepository {
  final FirebaseClassScheduleDataSource dataSource;

  ClassScheduleRepositoryImpl({required this.dataSource});

  @override
  Future<ClassSchedule?> getClassScheduleById(String id) {
    return dataSource.getClassScheduleById(id);
  }

  @override
  Future<List<ClassSchedule>> getAllClassSchedules() {
    return dataSource.getAllClassSchedules();
  }

  @override
  Future<List<ClassSchedule>> getClassSchedulesByTeacherId(String teacherId) {
    return dataSource.getClassSchedulesByTeacherId(teacherId);
  }

  @override
  Future<List<ClassSchedule>> getClassSchedulesByClassroomId(String classroomId) {
    return dataSource.getClassSchedulesByClassroomId(classroomId);
  }

  // Nuevo método agregado
  @override
  Future<List<ClassSchedule>> getClassSchedulesBySubjectId(String subjectId) {
    return dataSource.getClassSchedulesBySubjectId(subjectId);
  }
}

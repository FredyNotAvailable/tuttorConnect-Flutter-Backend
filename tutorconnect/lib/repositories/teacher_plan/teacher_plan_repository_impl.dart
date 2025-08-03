import 'package:tutorconnect/data/firebase_teacher_plan_datasource.dart';

import '../../models/teacher_plan.dart';
import 'teacher_plan_repository.dart';

class TeacherPlanRepositoryImpl implements TeacherPlanRepository {
  final FirebaseTeacherPlanDataSource dataSource;

  TeacherPlanRepositoryImpl({required this.dataSource});

  @override
  Future<TeacherPlan?> getTeacherPlanById(String id) {
    return dataSource.getTeacherPlanById(id);
  }

  @override
  Future<List<TeacherPlan>> getAllTeacherPlans() {
    return dataSource.getAllTeacherPlans();
  }

  @override
  Future<List<TeacherPlan>> getTeacherPlansByTeacherId(String teacherId) {
    return dataSource.getTeacherPlansByTeacherId(teacherId);
  }

  @override
  Future<List<TeacherPlan>> getActiveTeacherPlansByCareerId(String careerId) {
    return dataSource.getActiveTeacherPlansByCareerId(careerId);
  }
}

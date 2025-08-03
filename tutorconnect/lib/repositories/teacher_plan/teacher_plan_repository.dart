import '../../models/teacher_plan.dart';

abstract class TeacherPlanRepository {
  Future<TeacherPlan?> getTeacherPlanById(String id);

  Future<List<TeacherPlan>> getAllTeacherPlans();

  Future<List<TeacherPlan>> getTeacherPlansByTeacherId(String teacherId);

  Future<List<TeacherPlan>> getActiveTeacherPlansByCareerId(String careerId);
}

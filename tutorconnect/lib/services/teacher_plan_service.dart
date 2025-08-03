import '../repositories/teacher_plan/teacher_plan_repository.dart';
import '../models/teacher_plan.dart';

class TeacherPlanService {
  final TeacherPlanRepository _repository;

  TeacherPlanService(this._repository);

  Future<TeacherPlan?> getTeacherPlanById(String id) {
    return _repository.getTeacherPlanById(id);
  }

  Future<List<TeacherPlan>> getAllTeacherPlans() {
    return _repository.getAllTeacherPlans();
  }

  Future<List<TeacherPlan>> getTeacherPlansByTeacherId(String teacherId) {
    return _repository.getTeacherPlansByTeacherId(teacherId);
  }

  Future<List<TeacherPlan>> getActiveTeacherPlansByCareerId(String careerId) {
    return _repository.getActiveTeacherPlansByCareerId(careerId);
  }
}

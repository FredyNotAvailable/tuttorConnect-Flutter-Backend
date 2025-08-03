import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_teacher_plan_datasource.dart';
import 'package:tutorconnect/models/teacher_plan.dart';
import 'package:tutorconnect/repositories/teacher_plan/teacher_plan_repository.dart';
import 'package:tutorconnect/repositories/teacher_plan/teacher_plan_repository_impl.dart';
import 'package:tutorconnect/services/teacher_plan_service.dart';

/// 1. Proveedor del DataSource concreto
final firebaseTeacherPlanDataSourceProvider = Provider<FirebaseTeacherPlanDataSource>((ref) {
  return FirebaseTeacherPlanDataSource();
});

/// 2. Proveedor del Repositorio que usa el DataSource
final teacherPlanRepositoryProvider = Provider<TeacherPlanRepository>((ref) {
  final dataSource = ref.read(firebaseTeacherPlanDataSourceProvider);
  return TeacherPlanRepositoryImpl(dataSource: dataSource);
});

/// 3. Proveedor del Service que usa el Repositorio
final teacherPlanServiceProvider = Provider<TeacherPlanService>((ref) {
  final repository = ref.read(teacherPlanRepositoryProvider);
  return TeacherPlanService(repository);
});

/// 4. StateNotifier para manejar estado y acciones
class TeacherPlanNotifier extends StateNotifier<List<TeacherPlan>> {
  final TeacherPlanService _service;

  TeacherPlanNotifier(this._service) : super([]) {
    loadAllTeacherPlans();
  }

  Future<void> loadAllTeacherPlans() async {
    final plans = await _service.getAllTeacherPlans();
    state = plans;
  }

  Future<void> loadTeacherPlansByTeacherId(String teacherId) async {
    final plans = await _service.getTeacherPlansByTeacherId(teacherId);
    state = plans;
  }

  Future<void> loadActivePlansByCareer(String careerId) async {
    final plans = await _service.getActiveTeacherPlansByCareerId(careerId);
    state = plans;
  }

  Future<TeacherPlan?> getTeacherPlanById(String id) async {
    return await _service.getTeacherPlanById(id);
  }

  void clearPlans() {
    state = [];
  }
}

/// 5. Proveedor del StateNotifier
final teacherPlanProvider = StateNotifierProvider<TeacherPlanNotifier, List<TeacherPlan>>((ref) {
  final service = ref.read(teacherPlanServiceProvider);
  return TeacherPlanNotifier(service);
});


final teacherPlanBySubjectIdProvider = FutureProvider.family<TeacherPlan?, String>((ref, subjectId) async {
  // Acceso al service directamente para evitar limitación del StateNotifier (que no es async)
  final service = ref.read(teacherPlanServiceProvider);
  final allPlans = await service.getAllTeacherPlans();

  for (final plan in allPlans) {
    for (final materias in plan.subjectsByCycle.values) {
      if (materias.contains(subjectId)) {
        return plan;
      }
    }
  }
  return null;
});

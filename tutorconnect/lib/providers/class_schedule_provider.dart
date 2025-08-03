import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_class_schedule_datasource.dart';
import 'package:tutorconnect/models/class_schedule.dart';
import 'package:tutorconnect/repositories/class_schedule/class_schedule_repository.dart';
import 'package:tutorconnect/repositories/class_schedule/class_schedule_repository_impl.dart';
import 'package:tutorconnect/services/class_schedule_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseClassScheduleDataSourceProvider = Provider<FirebaseClassScheduleDataSource>((ref) {
  return FirebaseClassScheduleDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final classScheduleRepositoryProvider = Provider<ClassScheduleRepository>((ref) {
  final dataSource = ref.read(firebaseClassScheduleDataSourceProvider);
  return ClassScheduleRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final classScheduleServiceProvider = Provider<ClassScheduleService>((ref) {
  final repository = ref.read(classScheduleRepositoryProvider);
  return ClassScheduleService(repository);
});

// 4. StateNotifier para manejar estado y acciones (solo lectura)
class ClassScheduleNotifier extends StateNotifier<List<ClassSchedule>> {
  final ClassScheduleService _service;

  ClassScheduleNotifier(this._service) : super([]) {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    final schedules = await _service.getAllClassSchedules();
    state = schedules;
  }

  Future<ClassSchedule?> getScheduleById(String id) async {
    return await _service.getClassScheduleById(id);
  }

  Future<List<ClassSchedule>> getSchedulesByTeacherId(String teacherId) async {
    return await _service.getClassSchedulesByTeacherId(teacherId);
  }

  Future<List<ClassSchedule>> getSchedulesByClassroomId(String classroomId) async {
    return await _service.getClassSchedulesByClassroomId(classroomId);
  }

  // Nuevo método para obtener horarios activos por materia
  Future<List<ClassSchedule>> getActiveSchedulesBySubjectId(String subjectId) async {
    final allSchedules = await _service.getClassSchedulesBySubjectId(subjectId);
    final activeSchedules = allSchedules.where((schedule) => schedule.isActive).toList();
    return activeSchedules;
  }
}

// 5. Proveedor del StateNotifier
final classScheduleProvider = StateNotifierProvider<ClassScheduleNotifier, List<ClassSchedule>>((ref) {
  final service = ref.read(classScheduleServiceProvider);
  return ClassScheduleNotifier(service);
});

// 6. FutureProvider.family para obtener horarios activos por materia
final classSchedulesBySubjectProvider = FutureProvider.family<List<ClassSchedule>, String>((ref, subjectId) async {
  final notifier = ref.read(classScheduleProvider.notifier);
  return await notifier.getActiveSchedulesBySubjectId(subjectId);
});

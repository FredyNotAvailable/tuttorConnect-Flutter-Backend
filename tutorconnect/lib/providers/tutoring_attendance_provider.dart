import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_tutoring_attendance_datasource.dart';
import 'package:tutorconnect/models/tutoring_attendance.dart';
import 'package:tutorconnect/repositories/tutoring_attendance/tutoring_attendance_repository.dart';
import 'package:tutorconnect/repositories/tutoring_attendance/tutoring_attendance_repository_impl.dart';
import 'package:tutorconnect/services/tutoring_attendance_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseTutoringAttendanceDataSourceProvider = Provider<FirebaseTutoringAttendanceDataSource>((ref) {
  return FirebaseTutoringAttendanceDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final tutoringAttendanceRepositoryProvider = Provider<TutoringAttendanceRepository>((ref) {
  final dataSource = ref.read(firebaseTutoringAttendanceDataSourceProvider);
  return TutoringAttendanceRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final tutoringAttendanceServiceProvider = Provider<TutoringAttendanceService>((ref) {
  final repository = ref.read(tutoringAttendanceRepositoryProvider);
  return TutoringAttendanceService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class TutoringAttendanceNotifier extends StateNotifier<List<TutoringAttendance>> {
  final TutoringAttendanceService _service;

  TutoringAttendanceNotifier(this._service) : super([]) {
    loadAttendances();
  }

  Future<void> loadAttendances() async {
    final attendances = await _service.getAllAttendances();
    state = attendances;
  }

  Future<List<TutoringAttendance>> getAttendancesByTutoriaId(String tutoriaId) async {
    return await _service.getAttendancesByTutoriaId(tutoriaId);
  }

  Future<List<TutoringAttendance>> getAttendancesByStudentId(String studentId) async {
    return await _service.getAttendancesByStudentId(studentId);
  }

  Future<TutoringAttendance?> getAttendanceById(String id) async {
    return await _service.getAttendanceById(id);
  }

  Future<void> addAttendance(TutoringAttendance attendance) async {
    await _service.addAttendance(attendance);
    await loadAttendances();
  }

  Future<void> updateAttendance(TutoringAttendance attendance) async {
    await _service.updateAttendance(attendance);
    await loadAttendances();
  }
}

// 5. Proveedor del StateNotifier
final tutoringAttendanceProvider = StateNotifierProvider<TutoringAttendanceNotifier, List<TutoringAttendance>>((ref) {
  final service = ref.read(tutoringAttendanceServiceProvider);
  return TutoringAttendanceNotifier(service);
});

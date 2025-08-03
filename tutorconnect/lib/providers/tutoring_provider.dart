import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/repositories/tutoring/tutoring_repository.dart';
import 'package:tutorconnect/repositories/tutoring/tutoring_repository_impl.dart';

import '../data/firebase_tutoring_datasource.dart';
import '../services/tutoring_service.dart';
import '../models/tutoring.dart';

// 1. Proveedor del DataSource concreto
final firebaseTutoringDataSourceProvider = Provider<FirebaseTutoringDataSource>((ref) {
  return FirebaseTutoringDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final tutoringRepositoryProvider = Provider<TutoringRepository>((ref) {
  final dataSource = ref.read(firebaseTutoringDataSourceProvider);
  return TutoringRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final tutoringServiceProvider = Provider<TutoringService>((ref) {
  final repository = ref.read(tutoringRepositoryProvider);
  return TutoringService(repository);
});


// 5. StateNotifier para manejar estado y acciones
class TutoringNotifier extends StateNotifier<List<Tutoring>> {
  final TutoringService _service;

  TutoringNotifier(this._service) : super([]) {
    loadTutorings();
  }

  Future<void> loadTutorings() async {
    final tutorings = await _service.getAllTutorings();
    state = tutorings;
  }

  Future<Tutoring> addTutoring(Tutoring tutoring) async {
    final createdTutoring = await _service.addTutoring(tutoring);
    await loadTutorings();
    return createdTutoring;
  }

  Future<void> updateTutoring(Tutoring tutoring) async {
    await _service.updateTutoring(tutoring);
    await loadTutorings();
  }

  Future<Tutoring?> getTutoringById(String id) async {
    return await _service.getTutoringById(id);
  }

  Future<void> loadTutoringsByTeacherId(String teacherId) async {
    final tutorings = await _service.getTutoringsByTeacherId(teacherId);
    state = tutorings;
  }

  Future<void> loadTutoringsByStudentId(String studentId) async {
    final tutorings = await _service.getTutoringsByStudentId(studentId);
    state = tutorings;
  }

  Future<void> loadTutoringsByTutoringRequestIds(List<String> tutoringRequestIds) async {
    // Aquí haces la consulta con where('tutoringRequestIds', arrayContainsAny: tutoringRequestIds)
  }
}

// 6. Proveedor del StateNotifier
final tutoringProvider = StateNotifierProvider<TutoringNotifier, List<Tutoring>>((ref) {
  final service = ref.read(tutoringServiceProvider);
  return TutoringNotifier(service);
});

// 7. FutureProvider.family para obtener tutorías por materia
final tutoringsBySubjectProvider = FutureProvider.family<List<Tutoring>, String>((ref, subjectId) async {
  final service = ref.read(tutoringServiceProvider);
  return await service.getTutoringsBySubjectId(subjectId);
});

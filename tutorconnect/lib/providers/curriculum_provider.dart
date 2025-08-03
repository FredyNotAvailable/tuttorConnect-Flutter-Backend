import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_curriculum_datasource.dart';
import 'package:tutorconnect/repositories/curriculum/curriculum_repository.dart';
import 'package:tutorconnect/repositories/curriculum/curriculum_repository_impl.dart';
import 'package:tutorconnect/services/curriculum_service.dart';
import 'package:tutorconnect/models/curriculum.dart';

/// Proveedor del repositorio
final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  final dataSource = FirebaseCurriculumDataSource();
  return CurriculumRepositoryImpl(dataSource: dataSource);
});

/// Proveedor del servicio
final curriculumServiceProvider = Provider<CurriculumService>((ref) {
  final repository = ref.watch(curriculumRepositoryProvider);
  return CurriculumService(repository);
});

/// Currículum activo por carrera (útil para estudiantes)
final activeCurriculumByCareerProvider =
    FutureProvider.family<Curriculum?, String>((ref, careerId) {
  final service = ref.watch(curriculumServiceProvider);
  return service.getActiveCurriculumByCareerId(careerId);
});

/// Obtener currículum por ID
final curriculumByIdProvider = FutureProvider.family<Curriculum?, String>((ref, id) {
  final service = ref.watch(curriculumServiceProvider);
  return service.getCurriculumById(id);
});

/// Obtener currículum que contenga una materia específica
final curriculumBySubjectProvider = FutureProvider.family<Curriculum?, String>((ref, subjectId) {
  final service = ref.watch(curriculumServiceProvider);
  return service.getCurriculumBySubjectId(subjectId);
});

/// Todos los currículums (si los necesitas)
final allCurriculumsProvider = FutureProvider<List<Curriculum>>((ref) {
  final service = ref.watch(curriculumServiceProvider);
  return service.getAllCurriculums();
});

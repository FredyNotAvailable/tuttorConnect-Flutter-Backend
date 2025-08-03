import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_subject_datasource.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/repositories/subject/subject_repository.dart';
import 'package:tutorconnect/repositories/subject/subject_repository_impl.dart';
import 'package:tutorconnect/services/subject_service.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';

// 1. Proveedor del DataSource concreto
final firebaseSubjectDataSourceProvider = Provider<FirebaseSubjectDataSource>((ref) {
  return FirebaseSubjectDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final dataSource = ref.read(firebaseSubjectDataSourceProvider);
  return SubjectRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final subjectServiceProvider = Provider<SubjectService>((ref) {
  final repository = ref.read(subjectRepositoryProvider);
  return SubjectService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class SubjectNotifier extends StateNotifier<List<Subject>> {
  final SubjectService _service;

  SubjectNotifier(this._service) : super([]);

  Future<void> loadSubjects() async {
    try {
      final subjects = await _service.getAllSubjects();
      state = subjects;
    } catch (e) {
      // Manejar error si se desea
      state = [];
    }
  }

  Future<void> loadSubjectsByUser(User user) async {
    try {
      List<Subject> subjects = [];
      if (user.role == UserRole.student) {
        subjects = await _service.getSubjectsByStudentId(user.id);
      } else if (user.role == UserRole.teacher) {
        subjects = await _service.getSubjectsByTeacherId(user.id);
      }
      state = subjects;
    } catch (e) {
      state = [];
    }
  }

  Future<Subject?> getSubjectById(String id) async {
    return await _service.getSubjectById(id);
  }
}

// 5. Proveedor del StateNotifier
final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>((ref) {
  final service = ref.read(subjectServiceProvider);
  return SubjectNotifier(service);
});

// 6. FutureProvider.family para obtener materias según el usuario
final subjectsByUserProvider = FutureProvider.family<List<Subject>, User>((ref, user) async {
  final service = ref.read(subjectServiceProvider);
  if (user.role == UserRole.student) {
    return await service.getSubjectsByStudentId(user.id);
  } else if (user.role == UserRole.teacher) {
    return await service.getSubjectsByTeacherId(user.id);
  } else {
    return [];
  }
});

final subjectByIdProvider = FutureProvider.family<Subject?, String>((ref, subjectId) async {
  final subjectService = ref.read(subjectServiceProvider);
  final subject = await subjectService.getSubjectById(subjectId);
  return subject;
});


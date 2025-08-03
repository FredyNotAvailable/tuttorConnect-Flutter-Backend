import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_classroom_datasource.dart';
import 'package:tutorconnect/models/classroom.dart';
import 'package:tutorconnect/repositories/classroom/classroom_repository.dart';
import 'package:tutorconnect/repositories/classroom/classroom_repository_impl.dart';
import 'package:tutorconnect/services/classroom_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseClassroomDataSourceProvider = Provider<FirebaseClassroomDataSource>((ref) {
  return FirebaseClassroomDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final classroomRepositoryProvider = Provider<ClassroomRepository>((ref) {
  final dataSource = ref.read(firebaseClassroomDataSourceProvider);
  return ClassroomRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final classroomServiceProvider = Provider<ClassroomService>((ref) {
  final repository = ref.read(classroomRepositoryProvider);
  return ClassroomService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class ClassroomNotifier extends StateNotifier<List<Classroom>> {
  final ClassroomService _service;
  StreamSubscription<List<Classroom>>? _availableSubscription;

  ClassroomNotifier(this._service) : super([]) {
    loadClassrooms();
    // Suscripción al stream para aulas disponibles
    _availableSubscription = _service.watchAvailableClassrooms().listen((availableClassrooms) {
      state = availableClassrooms;
    });
  }

  Future<void> loadClassrooms() async {
    final classrooms = await _service.getAllClassrooms();
    state = classrooms;
  }

  Future<Classroom?> getClassroomById(String id) async {
    return await _service.getClassroomById(id);
  }

  @override
  void dispose() {
    _availableSubscription?.cancel();
    super.dispose();
  }
}

// 5. Proveedor del StateNotifier
final classroomProvider = StateNotifierProvider<ClassroomNotifier, List<Classroom>>((ref) {
  final service = ref.read(classroomServiceProvider);
  return ClassroomNotifier(service);
});

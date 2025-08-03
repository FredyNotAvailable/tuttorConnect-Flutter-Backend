import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_career_datasource.dart';
import 'package:tutorconnect/models/career.dart';
import 'package:tutorconnect/repositories/career/career_repository.dart';
import 'package:tutorconnect/repositories/career/career_repository_impl.dart';
import 'package:tutorconnect/services/career_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseCareerDataSourceProvider = Provider<FirebaseCareerDataSource>((ref) {
  return FirebaseCareerDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final careerRepositoryProvider = Provider<CareerRepository>((ref) {
  final dataSource = ref.read(firebaseCareerDataSourceProvider);
  return CareerRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final careerServiceProvider = Provider<CareerService>((ref) {
  final repository = ref.read(careerRepositoryProvider);
  return CareerService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class CareerNotifier extends StateNotifier<List<Career>> {
  final CareerService _service;

  CareerNotifier(this._service) : super([]) {
    loadCareers();
  }

  Future<void> loadCareers() async {
    final careers = await _service.getAllCareers();
    state = careers;
  }

  Future<Career?> getCareerById(String id) async {
    return await _service.getCareerById(id);
  }
}

// 5. Proveedor del StateNotifier
final careerProvider = StateNotifierProvider<CareerNotifier, List<Career>>((ref) {
  final service = ref.read(careerServiceProvider);
  return CareerNotifier(service);
});

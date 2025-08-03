import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_tutoring_request_datasource.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/repositories/tutoring_request/tutoring_request_repository.dart';
import 'package:tutorconnect/repositories/tutoring_request/tutoring_request_repository_impl.dart';
import 'package:tutorconnect/services/tutoring_request_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseTutoringRequestDataSourceProvider = Provider<FirebaseTutoringRequestDataSource>((ref) {
  return FirebaseTutoringRequestDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final tutoringRequestRepositoryProvider = Provider<TutoringRequestRepository>((ref) {
  final dataSource = ref.read(firebaseTutoringRequestDataSourceProvider);
  return TutoringRequestRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final tutoringRequestServiceProvider = Provider<TutoringRequestService>((ref) {
  final repository = ref.read(tutoringRequestRepositoryProvider);
  return TutoringRequestService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class TutoringRequestNotifier extends StateNotifier<List<TutoringRequest>> {
  final TutoringRequestService _service;

  TutoringRequestNotifier(this._service) : super([]) {
    loadTutoringRequests();
  }

  Future<void> loadTutoringRequests() async {
    final requests = await _service.getAllTutoringRequests();
    state = requests;
  }

  Future<List<TutoringRequest>> getTutoringRequestsByStudentId(String studentId) async {
    return await _service.getTutoringRequestsByStudentId(studentId);
  }

  Future<TutoringRequest?> getTutoringRequestById(String id) async {
    return await _service.getTutoringRequestById(id);
  }

  Future<TutoringRequest> addTutoringRequest(TutoringRequest tutoringRequest) async {
    final createdRequest = await _service.addTutoringRequest(tutoringRequest);
    await loadTutoringRequests();
    return createdRequest;
  }


  Future<void> updateTutoringRequest(TutoringRequest tutoringRequest) async {
    await _service.updateTutoringRequest(tutoringRequest);
    await loadTutoringRequests();
  }
}

// 5. Proveedor del StateNotifier
final tutoringRequestProvider = StateNotifierProvider<TutoringRequestNotifier, List<TutoringRequest>>((ref) {
  final service = ref.read(tutoringRequestServiceProvider);
  return TutoringRequestNotifier(service);
});

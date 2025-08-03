import 'package:tutorconnect/data/firebase_tutoring_request_datasource.dart';

import '../../models/tutoring_request.dart';
import 'tutoring_request_repository.dart';

class TutoringRequestRepositoryImpl implements TutoringRequestRepository {
  final FirebaseTutoringRequestDataSource dataSource;

  TutoringRequestRepositoryImpl({required this.dataSource});

  @override
  Future<TutoringRequest?> getTutoringRequestById(String id) {
    return dataSource.getTutoringRequestById(id);
  }

  @override
  Future<List<TutoringRequest>> getAllTutoringRequests() {
    return dataSource.getAllTutoringRequests();
  }

  @override
  Future<List<TutoringRequest>> getTutoringRequestsByStudentId(String studentId) {
    return dataSource.getTutoringRequestsByStudentId(studentId);
  }

  @override
  Future<TutoringRequest> addTutoringRequest(TutoringRequest tutoringRequest) {
    return dataSource.addTutoringRequest(tutoringRequest);
  }

  @override
  Future<void> updateTutoringRequest(TutoringRequest tutoringRequest) {
    return dataSource.updateTutoringRequest(tutoringRequest);
  }
}

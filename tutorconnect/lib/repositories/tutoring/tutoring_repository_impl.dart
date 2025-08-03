import 'package:tutorconnect/data/firebase_tutoring_datasource.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import '../../models/tutoring.dart';
import 'tutoring_repository.dart';

class TutoringRepositoryImpl implements TutoringRepository {
  final FirebaseTutoringDataSource dataSource;

  TutoringRepositoryImpl({required this.dataSource});

  @override
  Future<Tutoring?> getTutoringById(String id) {
    return dataSource.getTutoringById(id);
  }

  @override
  Future<List<Tutoring>> getAllTutorings() {
    return dataSource.getAllTutorings();
  }

  @override
  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) {
    return dataSource.getTutoringsByTeacherId(teacherId);
  }

  @override
  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) {
    return dataSource.getTutoringsByStudentId(studentId);
  }

  // Nuevo método para tutorías por lista de IDs de solicitudes
  @override
  Future<List<Tutoring>> getTutoringsByTutoringRequestIds(List<String> tutoringRequestIds) {
    return dataSource.getTutoringsByTutoringRequestIds(tutoringRequestIds);
  }

  @override
  Future<Tutoring> addTutoring(Tutoring tutoring) {
    return dataSource.addTutoring(tutoring);
  }

  @override
  Future<void> updateTutoring(Tutoring tutoring) {
    return dataSource.updateTutoring(tutoring);
  }
}

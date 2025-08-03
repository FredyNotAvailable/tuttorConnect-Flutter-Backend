import '../../models/tutoring.dart';

abstract class TutoringRepository {
  Future<Tutoring?> getTutoringById(String id);

  Future<List<Tutoring>> getAllTutorings();

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId);

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId);

    // Nuevo método para obtener tutorías por lista de IDs de solicitudes
  Future<List<Tutoring>> getTutoringsByTutoringRequestIds(List<String> tutoringRequestIds);

  Future<Tutoring> addTutoring(Tutoring tutoring);

  Future<void> updateTutoring(Tutoring tutoring);
}

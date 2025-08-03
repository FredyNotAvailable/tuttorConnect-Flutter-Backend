import '../models/tutoring.dart';
import '../repositories/tutoring/tutoring_repository.dart';

// 4. Clase TutoringService con el método faltante incluido
class TutoringService {
  final TutoringRepository _repository;

  TutoringService(this._repository);

  Future<List<Tutoring>> getAllTutorings() async {
    return await _repository.getAllTutorings();
  }

  Future<Tutoring> addTutoring(Tutoring tutoring) async {
    return await _repository.addTutoring(tutoring);
  }

  Future<void> updateTutoring(Tutoring tutoring) async {
    await _repository.updateTutoring(tutoring);
  }

  Future<Tutoring?> getTutoringById(String id) async {
    return await _repository.getTutoringById(id);
  }

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) async {
    return await _repository.getTutoringsByTeacherId(teacherId);
  }

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) async {
    return await _repository.getTutoringsByStudentId(studentId);
  }

  // Método que buscaba: filtra tutorías por materia (subjectId)
  Future<List<Tutoring>> getTutoringsBySubjectId(String subjectId) async {
    final allTutorings = await getAllTutorings();
    return allTutorings.where((tutoring) => tutoring.subjectId == subjectId).toList();
  }
}
import 'package:tutorconnect/models/curriculum.dart';
import 'package:tutorconnect/repositories/curriculum/curriculum_repository.dart';

class CurriculumService {
  final CurriculumRepository _repository;

  CurriculumService(this._repository);

  Future<Curriculum?> getCurriculumById(String id) {
    return _repository.getCurriculumById(id);
  }

  Future<List<Curriculum>> getAllCurriculums() {
    return _repository.getAllCurriculums();
  }

  Future<Curriculum?> getActiveCurriculumByCareerId(String careerId) {
    return _repository.getActiveCurriculumByCareerId(careerId);
  }

  Future<Curriculum?> getCurriculumBySubjectId(String subjectId) {
    return _repository.getCurriculumBySubjectId(subjectId);
  }
}

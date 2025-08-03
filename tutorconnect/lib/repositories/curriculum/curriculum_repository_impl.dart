import 'package:tutorconnect/data/firebase_curriculum_datasource.dart';
import 'package:tutorconnect/models/curriculum.dart';
import 'package:tutorconnect/repositories/curriculum/curriculum_repository.dart';

class CurriculumRepositoryImpl implements CurriculumRepository {
  final FirebaseCurriculumDataSource dataSource;

  CurriculumRepositoryImpl({required this.dataSource});

  @override
  Future<Curriculum?> getCurriculumById(String id) {
    return dataSource.getCurriculumById(id);
  }

  @override
  Future<List<Curriculum>> getAllCurriculums() {
    return dataSource.getAllCurriculums();
  }

  @override
  Future<Curriculum?> getActiveCurriculumByCareerId(String careerId) {
    return dataSource.getActiveCurriculumByCareerId(careerId);
  }

  @override
  Future<Curriculum?> getCurriculumBySubjectId(String subjectId) {
    return dataSource.getCurriculumBySubjectId(subjectId);
  }
}


import 'package:tutorconnect/models/curriculum.dart';

abstract class CurriculumRepository {
  Future<Curriculum?> getCurriculumById(String id);
  
  Future<List<Curriculum>> getAllCurriculums();
  
  Future<Curriculum?> getActiveCurriculumByCareerId(String careerId);

  Future<Curriculum?> getCurriculumBySubjectId(String subjectId);
}

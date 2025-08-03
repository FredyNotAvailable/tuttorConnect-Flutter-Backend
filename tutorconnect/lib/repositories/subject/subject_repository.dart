import '../../models/subject.dart';

abstract class SubjectRepository {
  Future<Subject?> getSubjectById(String id);

  Future<List<Subject>> getAllSubjects();

  Future<List<Subject>> getSubjectsByStudentId(String studentId);

  Future<List<Subject>> getSubjectsByTeacherId(String teacherId);
}

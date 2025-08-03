import 'package:tutorconnect/repositories/subject/subject_repository.dart';
import '../models/subject.dart';

class SubjectService {
  final SubjectRepository _subjectRepository;

  SubjectService(this._subjectRepository);

  Future<Subject?> getSubjectById(String id) async {
    return await _subjectRepository.getSubjectById(id);
  }

  Future<List<Subject>> getAllSubjects() async {
    return await _subjectRepository.getAllSubjects();
  }

  Future<List<Subject>> getSubjectsByStudentId(String studentId) async {
    return await _subjectRepository.getSubjectsByStudentId(studentId);
  }

  Future<List<Subject>> getSubjectsByTeacherId(String teacherId) async {
    return await _subjectRepository.getSubjectsByTeacherId(teacherId);
  }
}

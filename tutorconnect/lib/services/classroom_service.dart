import 'package:tutorconnect/repositories/classroom/classroom_repository.dart';
import '../models/classroom.dart';

class ClassroomService {
  final ClassroomRepository _classroomRepository;

  ClassroomService(this._classroomRepository);

  Future<Classroom?> getClassroomById(String id) async {
    return await _classroomRepository.getClassroomById(id);
  }

  Future<List<Classroom>> getAllClassrooms() async {
    return await _classroomRepository.getAllClassrooms();
  }

  Stream<List<Classroom>> watchAvailableClassrooms() {
    return _classroomRepository.watchAvailableClassrooms();
  }
}

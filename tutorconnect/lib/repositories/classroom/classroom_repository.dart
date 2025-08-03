import '../../models/classroom.dart';

abstract class ClassroomRepository {
  Future<Classroom?> getClassroomById(String id);

  Future<List<Classroom>> getAllClassrooms();
  
  // Nuevo método para obtener solo aulas disponibles
  Stream<List<Classroom>> watchAvailableClassrooms();
}

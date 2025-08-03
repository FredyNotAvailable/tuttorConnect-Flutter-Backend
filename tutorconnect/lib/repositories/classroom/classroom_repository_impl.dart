import 'package:tutorconnect/data/firebase_classroom_datasource.dart';

import '../../models/classroom.dart';
import 'classroom_repository.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final FirebaseClassroomDataSource dataSource;

  ClassroomRepositoryImpl({required this.dataSource});

  @override
  Future<Classroom?> getClassroomById(String id) {
    return dataSource.getClassroomById(id);
  }

  @override
  Future<List<Classroom>> getAllClassrooms() {
    return dataSource.getAllClassrooms();
  }

  @override
  Stream<List<Classroom>> watchAvailableClassrooms() {
    // Asumiendo que el dataSource tiene un método watchAvailableClassrooms que devuelve un Stream
    return dataSource.watchAvailableClassrooms();
  }
}

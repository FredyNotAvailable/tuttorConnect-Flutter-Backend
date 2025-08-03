import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tutorconnect/repositories/classroom/classroom_repository.dart';
import '../models/classroom.dart';

class FirebaseClassroomDataSource implements ClassroomRepository {
  final CollectionReference classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');
  final logger = Logger();

  @override
  Future<Classroom?> getClassroomById(String id) async {
    try {
      final doc = await classroomsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Aula encontrada: ID=$id');
        return Classroom.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe aula con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener aula', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener aula: $e');
    }
    return null;
  }

  @override
  Future<List<Classroom>> getAllClassrooms() async {
    try {
      final snapshot = await classroomsCollection.get();
      final classrooms = snapshot.docs
          .map((doc) => Classroom.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${classrooms.length} aulas');
      return classrooms;
    } catch (e, stackTrace) {
      logger.e('Error al obtener aulas', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar aulas: $e');
      return [];
    }
  }

  @override
  Stream<List<Classroom>> watchAvailableClassrooms() {
    return classroomsCollection
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Classroom.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}

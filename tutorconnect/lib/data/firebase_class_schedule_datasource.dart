import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/class_schedule.dart';

class FirebaseClassScheduleDataSource {
  final CollectionReference classSchedulesCollection =
      FirebaseFirestore.instance.collection('class_schedules');
  final logger = Logger();

  Future<ClassSchedule?> getClassScheduleById(String id) async {
    try {
      final doc = await classSchedulesCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Horario encontrado: ID=$id');
        return ClassSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe horario con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener horario', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener horario: $e');
    }
    return null;
  }

  Future<List<ClassSchedule>> getAllClassSchedules() async {
    try {
      final snapshot = await classSchedulesCollection.get();
      final schedules = snapshot.docs
          .map((doc) => ClassSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${schedules.length} horarios');
      return schedules;
    } catch (e, stackTrace) {
      logger.e('Error al obtener horarios', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar horarios: $e');
      return [];
    }
  }

  Future<List<ClassSchedule>> getClassSchedulesByTeacherId(String teacherId) async {
    try {
      final querySnapshot = await classSchedulesCollection
          .where('teacherId', isEqualTo: teacherId)
          .get();
      final schedules = querySnapshot.docs
          .map((doc) => ClassSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${schedules.length} horarios para docente');
      return schedules;
    } catch (e, stackTrace) {
      logger.e('Error al obtener horarios por docente', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar horarios del docente: $e');
      return [];
    }
  }

  Future<List<ClassSchedule>> getClassSchedulesByClassroomId(String classroomId) async {
    try {
      final querySnapshot = await classSchedulesCollection
          .where('classroomId', isEqualTo: classroomId)
          .get();
      final schedules = querySnapshot.docs
          .map((doc) => ClassSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${schedules.length} horarios para aula');
      return schedules;
    } catch (e, stackTrace) {
      logger.e('Error al obtener horarios por aula', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar horarios del aula: $e');
      return [];
    }
  }

  // Nuevo método agregado para obtener horarios por materia (subjectId)
  Future<List<ClassSchedule>> getClassSchedulesBySubjectId(String subjectId) async {
    try {
      final querySnapshot = await classSchedulesCollection
          .where('subjectId', isEqualTo: subjectId)
          .get();
      final schedules = querySnapshot.docs
          .map((doc) => ClassSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${schedules.length} horarios para materia');
      return schedules;
    } catch (e, stackTrace) {
      logger.e('Error al obtener horarios por materia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar horarios de la materia: $e');
      return [];
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/tutoring_attendance.dart';

class FirebaseTutoringAttendanceDataSource {
  final CollectionReference attendancesCollection =
      FirebaseFirestore.instance.collection('tutoring_attendance');
  final logger = Logger();

  Future<TutoringAttendance?> getAttendanceById(String id) async {
    try {
      final doc = await attendancesCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Asistencia encontrada: ID=$id');
        return TutoringAttendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe asistencia con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener asistencia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener asistencia: $e');
    }
    return null;
  }

  Future<List<TutoringAttendance>> getAllAttendances() async {
    try {
      final snapshot = await attendancesCollection.get();
      final attendances = snapshot.docs
          .map((doc) => TutoringAttendance.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${attendances.length} asistencias');
      return attendances;
    } catch (e, stackTrace) {
      logger.e('Error al obtener asistencias', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar asistencias: $e');
      return [];
    }
  }

  Future<List<TutoringAttendance>> getAttendancesByTutoriaId(String tutoriaId) async {
    try {
      final querySnapshot = await attendancesCollection
          .where('tutoriaId', isEqualTo: tutoriaId)
          .orderBy('date', descending: true)
          .get();
      final attendances = querySnapshot.docs
          .map((doc) => TutoringAttendance.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${attendances.length} asistencias para tutoría');
      return attendances;
    } catch (e, stackTrace) {
      logger.e('Error al obtener asistencias por tutoría', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar asistencias de tutoría: $e');
      return [];
    }
  }

  Future<List<TutoringAttendance>> getAttendancesByStudentId(String studentId) async {
    try {
      final querySnapshot = await attendancesCollection
          .where('studentId', isEqualTo: studentId)
          .orderBy('date', descending: true)
          .get();
      final attendances = querySnapshot.docs
          .map((doc) => TutoringAttendance.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${attendances.length} asistencias para estudiante');
      return attendances;
    } catch (e, stackTrace) {
      logger.e('Error al obtener asistencias por estudiante', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar asistencias del estudiante: $e');
      return [];
    }
  }

  Future<void> addAttendance(TutoringAttendance attendance) async {
    try {
      await attendancesCollection.add(attendance.toMap());
      Fluttertoast.showToast(msg: 'Asistencia agregada');
    } catch (e, stackTrace) {
      logger.e('Error al agregar asistencia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al agregar asistencia: $e');
    }
  }

  Future<void> updateAttendance(TutoringAttendance attendance) async {
    try {
      await attendancesCollection.doc(attendance.id).update(attendance.toMap());
      Fluttertoast.showToast(msg: 'Asistencia actualizada');
    } catch (e, stackTrace) {
      logger.e('Error al actualizar asistencia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al actualizar asistencia: $e');
    }
  }
}

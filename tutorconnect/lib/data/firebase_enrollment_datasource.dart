import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/enrollment.dart';

class FirebaseEnrollmentDataSource {
  final CollectionReference enrollmentsCollection =
      FirebaseFirestore.instance.collection('enrollments');
  final logger = Logger();

  Future<Enrollment?> getEnrollmentById(String id) async {
    try {
      final doc = await enrollmentsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Matrícula encontrada: ID=$id');
        return Enrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe matrícula con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrícula', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener matrícula: $e');
    }
    return null;
  }

  Future<List<Enrollment>> getAllEnrollments() async {
    try {
      final snapshot = await enrollmentsCollection.get();
      final enrollments = snapshot.docs
          .map((doc) => Enrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${enrollments.length} matrículas');
      return enrollments;
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrículas', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar matrículas: $e');
      return [];
    }
  }
}

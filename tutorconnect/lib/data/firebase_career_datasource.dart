import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/career.dart';

class FirebaseCareerDataSource {
  final CollectionReference careersCollection =
      FirebaseFirestore.instance.collection('careers');
  final logger = Logger();

  Future<Career?> getCareerById(String id) async {
    try {
      final doc = await careersCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Carrera encontrada: ID=$id');
        return Career.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe carrera con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener carrera', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener carrera: $e');
    }
    return null;
  }

  Future<List<Career>> getAllCareers() async {
    try {
      final snapshot = await careersCollection.get();
      final careers = snapshot.docs
          .map((doc) => Career.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${careers.length} carreras');
      return careers;
    } catch (e, stackTrace) {
      logger.e('Error al obtener todas las carreras', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar carreras: $e');
      return [];
    }
  }
}

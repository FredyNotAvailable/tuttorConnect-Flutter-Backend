import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/curriculum.dart';

class FirebaseCurriculumDataSource {
  final CollectionReference curriculumsCollection =
      FirebaseFirestore.instance.collection('curriculums');
  final logger = Logger();

  Future<Curriculum?> getCurriculumById(String id) async {
    try {
      final doc = await curriculumsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Curriculum encontrado: ID=$id');
        return Curriculum.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe curriculum con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener curriculum', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener curriculum: $e');
    }
    return null;
  }

  Future<List<Curriculum>> getAllCurriculums() async {
    try {
      final snapshot = await curriculumsCollection.get();
      final curriculums = snapshot.docs
          .map((doc) =>
              Curriculum.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${curriculums.length} curriculums');
      return curriculums;
    } catch (e, stackTrace) {
      logger.e('Error al obtener curriculums', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar curriculums: $e');
      return [];
    }
  }

  Future<List<Curriculum>> getCurriculumsByCareerId(String careerId) async {
    try {
      final snapshot = await curriculumsCollection
          .where('careerId', isEqualTo: careerId)
          .get();

      final curriculums = snapshot.docs
          .map((doc) =>
              Curriculum.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      Fluttertoast.showToast(
          msg: 'Se cargaron ${curriculums.length} curriculums para careerId: $careerId');
      return curriculums;
    } catch (e, stackTrace) {
      logger.e('Error al obtener curriculums por careerId',
          error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(
          msg: 'Error al cargar curriculums por careerId: $e');
      return [];
    }
  }

  Future<Curriculum?> getActiveCurriculumByCareerId(String careerId) async {
    try {
      final query = await curriculumsCollection
          .where('careerId', isEqualTo: careerId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        Fluttertoast.showToast(msg: 'Curriculum activo encontrado para careerId: $careerId');
        return Curriculum.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No hay curriculum activo para careerId: $careerId');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener curriculum activo', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener curriculum activo: $e');
    }
    return null;
  }

  Future<Curriculum?> getCurriculumBySubjectId(String subjectId) async {
    try {
      final query = await curriculumsCollection.get();

      for (final doc in query.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final subjectsByCycle = data['subjectsByCycle'];

        if (subjectsByCycle is Map<String, dynamic>) {
          for (final entry in subjectsByCycle.entries) {
            final value = entry.value;
            if (value is List && value.contains(subjectId)) {
              Fluttertoast.showToast(msg: 'Curriculum encontrado para subjectId: $subjectId');
              return Curriculum.fromMap(data, doc.id);
            }
          }
        }
      }
      Fluttertoast.showToast(msg: 'No se encontró curriculum para subjectId: $subjectId');
    } catch (e, stackTrace) {
      logger.e('Error al obtener curriculum por subjectId', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener curriculum por subjectId: $e');
    }
    return null;
  }
}

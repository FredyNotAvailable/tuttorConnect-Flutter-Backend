import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/tutoring_request.dart';

class FirebaseTutoringRequestDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference tutoringRequestsCollection =
      FirebaseFirestore.instance.collection('tutoring_requests');
  final logger = Logger();

  Future<TutoringRequest?> getTutoringRequestById(String id) async {
    try {
      final doc = await tutoringRequestsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Solicitud de tutoría encontrada: ID=$id');
        return TutoringRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe solicitud con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener solicitud de tutoría', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener solicitud: $e');
    }
    return null;
  }

  Future<List<TutoringRequest>> getAllTutoringRequests() async {
    try {
      final snapshot = await tutoringRequestsCollection.get();
      final requests = snapshot.docs
          .map((doc) => TutoringRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${requests.length} solicitudes de tutoría');
      return requests;
    } catch (e, stackTrace) {
      logger.e('Error al obtener solicitudes de tutoría', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar solicitudes: $e');
      return [];
    }
  }

  Future<List<TutoringRequest>> getTutoringRequestsByStudentId(String studentId) async {
    try {
      final querySnapshot = await tutoringRequestsCollection
          .where('studentId', isEqualTo: studentId)
          .get();

      final requests = querySnapshot.docs
          .map((doc) => TutoringRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      Fluttertoast.showToast(msg: 'Se cargaron ${requests.length} solicitudes para estudiante');
      return requests;
    } catch (e, stackTrace) {
      logger.e('Error al obtener solicitudes por estudiante', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar solicitudes del estudiante: $e');
      return [];
    }
  }

  Future<TutoringRequest> addTutoringRequest(TutoringRequest request) async {
    try {
      final docRef = await tutoringRequestsCollection.add(request.toMap());
      final createdRequest = request.copyWith(id: docRef.id);
      Fluttertoast.showToast(msg: 'Solicitud de tutoría agregada');
      return createdRequest;
    } catch (e, stackTrace) {
      logger.e('Error al agregar solicitud', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al agregar solicitud: $e');
      rethrow;
    }
  }

  Future<void> updateTutoringRequest(TutoringRequest request) async {
    try {
      await tutoringRequestsCollection.doc(request.id).update(request.toMap());
      Fluttertoast.showToast(msg: 'Solicitud de tutoría actualizada');
    } catch (e, stackTrace) {
      logger.e('Error al actualizar solicitud', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al actualizar solicitud: $e');
    }
  }
}

import '../models/tutoring.dart';
import '../repositories/tutoring/tutoring_repository.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;


// 4. Clase TutoringService con el método faltante incluido
class TutoringService {
  final TutoringRepository _repository;

  TutoringService(this._repository);

  Future<List<Tutoring>> getAllTutorings() async {
    return await _repository.getAllTutorings();
  }

 Future<Tutoring> addTutoring(Tutoring tutoring) async {
    // 1. Crear la tutoría en Firestore
    final createdTutoring = await _repository.addTutoring(tutoring);

    // 2. Obtener tokens FCM de estudiantes inscritos
    final studentTokens = await fetchFCMTokensForStudents(createdTutoring.studentIds);

    if (studentTokens.isNotEmpty) {
      final apiUrl = Uri.parse('http://10.0.2.2:3000/send-tutoring-notification'); // Cambia si es necesario

      final body = jsonEncode({
        'tokens': studentTokens,
        'topic': createdTutoring.topic,
        'date': createdTutoring.date.toIso8601String(),
        'tutoringId': createdTutoring.id,
      });

      try {
        final response = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          print('✅ Notificaciones enviadas correctamente');
        } else {
          print('❌ Error en la API de notificaciones: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('❌ Error llamando API de notificaciones: $e');
      }
    } else {
      print('⚠️ No hay tokens FCM para enviar notificaciones');
    }

    return createdTutoring;
  }

  // Función para obtener tokens FCM desde Firestore
  Future<List<String>> fetchFCMTokensForStudents(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];

    final firestore = FirebaseFirestore.instance;
    List<String> tokens = [];

    const batchSize = 10; // Límite máximo para 'whereIn' en Firestore
    for (var i = 0; i < studentIds.length; i += batchSize) {
      final batchIds = studentIds.skip(i).take(batchSize).toList();

      final querySnapshot = await firestore
          .collection('usuarios')  // Cambia si tu colección tiene otro nombre
          .where('id', whereIn: batchIds)
          .get();

      for (var doc in querySnapshot.docs) {
        final token = doc.data()['fcmToken'] as String?;
        if (token != null && token.isNotEmpty) {
          tokens.add(token);
        }
      }
    }

    return tokens;
  }

  Future<void> updateTutoring(Tutoring tutoring) async {
    await _repository.updateTutoring(tutoring);
  }

  Future<Tutoring?> getTutoringById(String id) async {
    return await _repository.getTutoringById(id);
  }

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) async {
    return await _repository.getTutoringsByTeacherId(teacherId);
  }

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) async {
    return await _repository.getTutoringsByStudentId(studentId);
  }

  // Método que buscaba: filtra tutorías por materia (subjectId)
  Future<List<Tutoring>> getTutoringsBySubjectId(String subjectId) async {
    final allTutorings = await getAllTutorings();
    return allTutorings.where((tutoring) => tutoring.subjectId == subjectId).toList();
  }
}
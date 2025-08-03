import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tutorconnect/repositories/tutoring/tutoring_repository.dart';
import '../models/tutoring.dart';

class FirebaseTutoringDataSource implements TutoringRepository {
  final CollectionReference tutoringCollection =
      FirebaseFirestore.instance.collection('tutorings');
  final Logger logger = Logger();

  @override
  Future<Tutoring?> getTutoringById(String id) async {
    try {
      final doc = await tutoringCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Tutoring found: ID=$id');
        return Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No tutoring found with ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error getting tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error getting tutoring: $e');
    }
    return null;
  }

  @override
  Future<List<Tutoring>> getAllTutorings() async {
    try {
      final snapshot = await tutoringCollection.get();
      final tutorings = snapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings: $e');
      return [];
    }
  }

  @override
  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) async {
    try {
      final querySnapshot = await tutoringCollection
          .where('teacherId', isEqualTo: teacherId)
          .get();
      final tutorings = querySnapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings for teacher');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings by teacher', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings for teacher: $e');
      return [];
    }
  }

  @override
  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) async {
    try {
      final querySnapshot = await tutoringCollection
          .where('tutoringRequestIds', arrayContains: studentId)
          .get();
      final tutorings = querySnapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings for student');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings by student', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings for student: $e');
      return [];
    }
  }

  @override
  Future<List<Tutoring>> getTutoringsByTutoringRequestIds(List<String> tutoringRequestIds) async {
    try {
      if (tutoringRequestIds.isEmpty) {
        return [];
      }

      // Firestore no permite consultas "arrayContainsAny" con más de 10 elementos
      // Por eso, si tienes más de 10 IDs, hay que hacer varias consultas o manejarlo distinto.
      final chunks = <List<String>>[];
      const chunkSize = 10;

      for (var i = 0; i < tutoringRequestIds.length; i += chunkSize) {
        chunks.add(
          tutoringRequestIds.sublist(
            i,
            i + chunkSize > tutoringRequestIds.length ? tutoringRequestIds.length : i + chunkSize,
          ),
        );
      }

      List<Tutoring> results = [];

      for (final chunk in chunks) {
        final querySnapshot = await tutoringCollection
            .where('tutoringRequestIds', arrayContainsAny: chunk)
            .get();

        results.addAll(
          querySnapshot.docs
              .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
      }

      Fluttertoast.showToast(msg: 'Loaded ${results.length} tutorings by request IDs');
      return results;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings by tutoringRequestIds', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings by requests: $e');
      return [];
    }
  }


  @override
  Future<Tutoring> addTutoring(Tutoring tutoring) async {
    try {
      final docRef = await tutoringCollection.add(tutoring.toMap());
      final createdTutoring = tutoring.copyWith(id: docRef.id);
      Fluttertoast.showToast(msg: 'Tutoring added');
      return createdTutoring;
    } catch (e, stackTrace) {
      logger.e('Error adding tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error adding tutoring: $e');
      throw Exception('Failed to add tutoring');
    }
  }


  @override
  Future<void> updateTutoring(Tutoring tutoring) async {
    try {
      await tutoringCollection.doc(tutoring.id).update(tutoring.toMap());
      Fluttertoast.showToast(msg: 'Tutoring updated');
    } catch (e, stackTrace) {
      logger.e('Error updating tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error updating tutoring: $e');
    }
  }
}

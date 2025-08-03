import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/repositories/subject/subject_repository.dart';

enum SubjectEnrollmentStatus {
  inProgress,
  failed,
  passed,
}

class FirebaseSubjectDataSource implements SubjectRepository {
  final CollectionReference subjectsCollection =
      FirebaseFirestore.instance.collection('subjects');

  final CollectionReference enrollmentsCollection =
      FirebaseFirestore.instance.collection('subject_enrollments');

  final CollectionReference teacherPlansCollection =
      FirebaseFirestore.instance.collection('teacher_plans');

  final logger = Logger();

  String _statusToString(SubjectEnrollmentStatus status) {
    switch (status) {
      case SubjectEnrollmentStatus.inProgress:
        return 'inProgress';
      case SubjectEnrollmentStatus.failed:
        return 'failed';
      case SubjectEnrollmentStatus.passed:
        return 'passed';
    }
  }

  /// Divide una lista en sublistas de tamaño máximo [chunkSize].
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  @override
  Future<Subject?> getSubjectById(String id) async {
    try {
      final doc = await subjectsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Subject found: ID=$id');
        return Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No subject found with ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching subject', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error fetching subject: $e');
    }
    return null;
  }

  @override
  Future<List<Subject>> getAllSubjects() async {
    try {
      final snapshot = await subjectsCollection.get();
      final subjects = snapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${subjects.length} subjects');
      return subjects;
    } catch (e, stackTrace) {
      logger.e('Error loading subjects', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading subjects: $e');
      return [];
    }
  }

  @override
  Future<List<Subject>> getSubjectsByStudentId(String studentId) async {
    try {
      final statusFilter = _statusToString(SubjectEnrollmentStatus.inProgress);
      final enrollmentSnapshot = await enrollmentsCollection
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: statusFilter)
          .get();

      if (enrollmentSnapshot.docs.isEmpty) return [];

      final subjectIds = enrollmentSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['subjectId'] as String)
          .toSet()
          .toList();

      if (subjectIds.isEmpty) return [];

      final List<Subject> subjects = [];

      // Firestore allows max 10 elements in whereIn queries, dividimos en chunks
      final chunks = _chunkList<String>(subjectIds, 10);

      for (var chunk in chunks) {
        final querySnapshot = await subjectsCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        subjects.addAll(querySnapshot.docs
            .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id)));
      }

      return subjects;
    } catch (e, stackTrace) {
      logger.e('Error fetching subjects for student', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error fetching student subjects: $e');
      return [];
    }
  }

  @override
  Future<List<Subject>> getSubjectsByTeacherId(String teacherId) async {
    try {
      final plansSnapshot = await teacherPlansCollection
          .where('teacherId', isEqualTo: teacherId)
          .where('isActive', isEqualTo: true)
          .get();

      if (plansSnapshot.docs.isEmpty) return [];

      final Set<String> subjectIds = {};

      for (var doc in plansSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Map<String, dynamic>? subjectsByCycle = data['subjectsByCycle'] as Map<String, dynamic>?;

        if (subjectsByCycle != null) {
          for (var cycleSubjects in subjectsByCycle.values) {
            if (cycleSubjects is List) {
              for (var subjectId in cycleSubjects) {
                if (subjectId is String) {
                  subjectIds.add(subjectId);
                }
              }
            }
          }
        }
      }

      if (subjectIds.isEmpty) return [];

      final List<Subject> subjects = [];

      final chunks = _chunkList<String>(subjectIds.toList(), 10);

      for (var chunk in chunks) {
        final querySnapshot = await subjectsCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        subjects.addAll(querySnapshot.docs
            .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id)));
      }

      return subjects;
    } catch (e, stackTrace) {
      logger.e('Error fetching subjects for teacher', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error fetching teacher subjects: $e');
      return [];
    }
  }
}

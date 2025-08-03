import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tutorconnect/repositories/teacher_plan/teacher_plan_repository.dart';

import '../models/teacher_plan.dart';

class FirebaseTeacherPlanDataSource implements TeacherPlanRepository{
  final CollectionReference teacherPlansCollection =
      FirebaseFirestore.instance.collection('teacher_plans');

  final logger = Logger();

  @override
  Future<TeacherPlan?> getTeacherPlanById(String id) async {
    try {
      final doc = await teacherPlansCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'TeacherPlan found: ID=$id');
        return TeacherPlan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No TeacherPlan found with ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error getting TeacherPlan', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error getting TeacherPlan: $e');
    }
    return null;
  }

  @override
  Future<List<TeacherPlan>> getAllTeacherPlans() async {
    try {
      final snapshot = await teacherPlansCollection.get();
      final plans = snapshot.docs
          .map((doc) => TeacherPlan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${plans.length} teacher plans');
      return plans;
    } catch (e, stackTrace) {
      logger.e('Error getting teacher plans', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading teacher plans: $e');
      return [];
    }
  }

  @override
  Future<List<TeacherPlan>> getTeacherPlansByTeacherId(String teacherId) async {
    try {
      final snapshot = await teacherPlansCollection
          .where('teacherId', isEqualTo: teacherId)
          .get();

      final plans = snapshot.docs
          .map((doc) => TeacherPlan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      Fluttertoast.showToast(msg: 'Loaded ${plans.length} teacher plans for teacherId: $teacherId');
      return plans;
    } catch (e, stackTrace) {
      logger.e('Error getting teacher plans by teacherId', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading teacher plans by teacherId: $e');
      return [];
    }
  }

  @override
  Future<List<TeacherPlan>> getActiveTeacherPlansByCareerId(String careerId) async {
    try {
      final snapshot = await teacherPlansCollection
          .where('careerId', isEqualTo: careerId)
          .where('isActive', isEqualTo: true)
          .get();

      final plans = snapshot.docs
          .map((doc) => TeacherPlan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      Fluttertoast.showToast(msg: 'Loaded ${plans.length} active teacher plans for careerId: $careerId');
      return plans;
    } catch (e, stackTrace) {
      logger.e('Error getting active teacher plans by careerId', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading active teacher plans by careerId: $e');
      return [];
    }
  }
}

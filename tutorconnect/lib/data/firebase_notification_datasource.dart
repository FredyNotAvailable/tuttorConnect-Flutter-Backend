import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/notification.dart';

class FirebaseNotificationDataSource {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');
  final logger = Logger();

  Future<NotificationModel?> getNotificationById(String id) async {
    try {
      final doc = await notificationsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Notificación encontrada: ID=$id');
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe notificación con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener notificación', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener notificación: $e');
    }
    return null;
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final snapshot = await notificationsCollection.get();
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${notifications.length} notificaciones');
      return notifications;
    } catch (e, stackTrace) {
      logger.e('Error al obtener notificaciones', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar notificaciones: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    try {
      final querySnapshot = await notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('sentAt', descending: true)
          .get();
      final notifications = querySnapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${notifications.length} notificaciones para usuario');
      return notifications;
    } catch (e, stackTrace) {
      logger.e('Error al obtener notificaciones por usuario', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar notificaciones de usuario: $e');
      return [];
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await notificationsCollection.add(notification.toMap());
      Fluttertoast.showToast(msg: 'Notificación agregada');
    } catch (e, stackTrace) {
      logger.e('Error al agregar notificación', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al agregar notificación: $e');
    }
  }

  Future<void> updateNotification(NotificationModel notification) async {
    try {
      await notificationsCollection.doc(notification.id).update(notification.toMap());
      Fluttertoast.showToast(msg: 'Notificación actualizada');
    } catch (e, stackTrace) {
      logger.e('Error al actualizar notificación', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al actualizar notificación: $e');
    }
  }
}

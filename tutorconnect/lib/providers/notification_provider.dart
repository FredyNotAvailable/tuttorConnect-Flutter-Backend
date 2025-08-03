import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_notification_datasource.dart';
import 'package:tutorconnect/models/notification.dart';
import 'package:tutorconnect/repositories/notification/notification_repository.dart';
import 'package:tutorconnect/repositories/notification/notification_repository_impl.dart';
import 'package:tutorconnect/services/notification_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseNotificationDataSourceProvider = Provider<FirebaseNotificationDataSource>((ref) {
  return FirebaseNotificationDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dataSource = ref.read(firebaseNotificationDataSourceProvider);
  return NotificationRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return NotificationService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  final NotificationService _service;

  NotificationNotifier(this._service) : super([]) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final notifications = await _service.getAllNotifications();
    state = notifications;
  }

  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    return await _service.getNotificationsByUserId(userId);
  }

  Future<NotificationModel?> getNotificationById(String id) async {
    return await _service.getNotificationById(id);
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _service.addNotification(notification);
    await loadNotifications();
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await _service.updateNotification(notification);
    await loadNotifications();
  }
}

// 5. Proveedor del StateNotifier
final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  final service = ref.read(notificationServiceProvider);
  return NotificationNotifier(service);
});

import 'package:tutorconnect/repositories/notification/notification_repository.dart';
import '../models/notification.dart';

class NotificationService {
  final NotificationRepository _notificationRepository;

  NotificationService(this._notificationRepository);

  Future<NotificationModel?> getNotificationById(String id) async {
    return await _notificationRepository.getNotificationById(id);
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    return await _notificationRepository.getAllNotifications();
  }

  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    return await _notificationRepository.getNotificationsByUserId(userId);
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _notificationRepository.addNotification(notification);
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await _notificationRepository.updateNotification(notification);
  }
}

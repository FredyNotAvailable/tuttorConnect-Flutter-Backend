import '../../models/notification.dart';

abstract class NotificationRepository {
  Future<NotificationModel?> getNotificationById(String id);

  Future<List<NotificationModel>> getAllNotifications();

  Future<List<NotificationModel>> getNotificationsByUserId(String userId);

  Future<void> addNotification(NotificationModel notification);

  Future<void> updateNotification(NotificationModel notification);
}

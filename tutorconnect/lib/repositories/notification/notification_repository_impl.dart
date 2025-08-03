import 'package:tutorconnect/data/firebase_notification_datasource.dart';

import '../../models/notification.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseNotificationDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<NotificationModel?> getNotificationById(String id) {
    return dataSource.getNotificationById(id);
  }

  @override
  Future<List<NotificationModel>> getAllNotifications() {
    return dataSource.getAllNotifications();
  }

  @override
  Future<List<NotificationModel>> getNotificationsByUserId(String userId) {
    return dataSource.getNotificationsByUserId(userId);
  }

  @override
  Future<void> addNotification(NotificationModel notification) {
    return dataSource.addNotification(notification);
  }

  @override
  Future<void> updateNotification(NotificationModel notification) {
    return dataSource.updateNotification(notification);
  }
}

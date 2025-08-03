import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handler para mensajes recibidos en background o cuando la app está terminada
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📥 Mensaje recibido en background: ${message.messageId}');
  // Aquí puedes hacer tareas en background, actualizar datos, etc.
}

class PushNotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Function(RemoteMessage)? _onMessageCallback;

  /// Llamar desde main() al iniciar la app
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Acción al tocar la notificación local
        print('Notificación local seleccionada con payload: ${response.payload}');
        // Aquí puedes navegar o realizar alguna acción
      },
    );
    // Registra el handler para mensajes en background (importante)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Solicita permisos en iOS (Android los concede por defecto)
    await _firebaseMessaging.requestPermission();

    // Maneja mensajes cuando la app está en segundo plano y el usuario abre la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Maneja mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Mensaje en primer plano: ${message.notification?.title}');
      _showLocalNotification(message); // Muestra notificación local en foreground
      if (_onMessageCallback != null) {
        _onMessageCallback!(message);
      }
    });

    // Opcional: si la app fue abierta desde una notificación estando terminada
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Muestra una notificación local cuando la app está en foreground
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Canal para notificaciones de TutorConnect',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: 'notificacion_payload',
    );
  }

  /// Registra un callback para mensajes en primer plano
  static void onMessageListener(Function(RemoteMessage) callback) {
    _onMessageCallback = callback;
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('📲 Usuario abrió la app desde la notificación: ${message.notification?.title}');
    // Aquí puedes navegar o actualizar UI según el payload
  }

  static Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }
}

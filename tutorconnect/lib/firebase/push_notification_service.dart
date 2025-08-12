import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handler para mensajes recibidos en background o cuando la app está terminada
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📥 Mensaje recibido en background: ${message.messageId}');
  // Aquí puedes realizar tareas en background, actualizar datos, etc.
}

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Function(RemoteMessage)? _onMessageCallback;

  /// Inicializa la configuración de Firebase Messaging y notificaciones locales
  /// Debe llamarse desde main() al iniciar la app
  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Acción al tocar la notificación local
        print(
            'Notificación local seleccionada con payload: ${response.payload}');
        // Aquí puedes navegar o realizar alguna acción adicional
      },
    );

    // Registrar handler para mensajes en background (importante)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Solicitar permisos para iOS (en Android no es necesario)
    await _firebaseMessaging.requestPermission();

    // Maneja cuando el usuario abre la app desde una notificación en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Maneja mensajes recibidos en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Mensaje en primer plano: ${message.notification?.title}');
      _showLocalNotification(
          message); // Mostrar notificación local en foreground
      if (_onMessageCallback != null) {
        _onMessageCallback!(message);
      }
    });

    // Si la app fue abierta desde una notificación estando terminada
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Muestra una notificación local cuando la app está en primer plano
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Canal para notificaciones de TutorConnect',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: 'notificacion_payload',
    );
  }

  /// Registra un callback para recibir mensajes en primer plano
  static void onMessageListener(Function(RemoteMessage) callback) {
    _onMessageCallback = callback;
  }

  /// Maneja cuando el usuario abre la app desde una notificación
  static void _handleMessageOpenedApp(RemoteMessage message) {
    print(
        '📲 Usuario abrió la app desde la notificación: ${message.notification?.title}');
    // Aquí puedes navegar o actualizar la UI según el payload
  }

  /// Obtiene el token FCM para notificaciones push
  static Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }
}

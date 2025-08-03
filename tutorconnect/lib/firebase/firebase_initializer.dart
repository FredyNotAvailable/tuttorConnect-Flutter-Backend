import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Message: ${message.messageId}');
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Permiso de notificación concedido');
  } else {
    print('❌ Permiso de notificación denegado o no determinado');
  }
}

Future<bool> initializeFirebaseAndMessaging() async {
  try {
    await Firebase.initializeApp();
    await requestNotificationPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 Mensaje recibido en primer plano');
      print('Título: ${message.notification?.title}');
      print('Cuerpo: ${message.notification?.body}');
      print('Data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Usuario abrió la notificación');
      print('Data: ${message.data}');
    });

    return true;
  } catch (e) {
    print('❌ Error inicializando Firebase: $e');
    return false;
  }
}

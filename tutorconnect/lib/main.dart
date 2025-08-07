import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Asegúrate de importar esto
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorconnect/firebase/push_notification_service.dart';
import 'package:tutorconnect/routes/app_routes.dart';
import 'package:tutorconnect/firebase/firebase_initializer.dart';
import 'package:tutorconnect/firebase/firebase_providers.dart';
import 'package:tutorconnect/screens/auth_gate.dart'; // <-- Importa el nuevo widget

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final connected = await initializeFirebaseAndMessaging();

  if (connected) {
    await PushNotificationService
        .initialize(); // Inicializa notificaciones push
  }

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Listener cuando se abre la app desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navegar a Home y eliminar historial para evitar volver atrás
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseConnectedAsync = ref.watch(firebaseConnectedProvider);

    return firebaseConnectedAsync.when(
      data: (connected) {
        if (!connected) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Error de conexión con Firebase',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          );
        }
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'TutorConnect',
              debugShowCheckedModeBanner: false,
              home: const AuthGate(),
              onGenerateRoute: AppRoutes.generateRoute,
              theme: ThemeData(
                brightness: Brightness.light,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  iconTheme: IconThemeData(color: Colors.black),
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                  elevation: 1,
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                ),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al conectar con Firebase: $error')),
        ),
      ),
    );
  }
}

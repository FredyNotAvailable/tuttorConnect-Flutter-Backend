import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/firebase/push_notification_service.dart';
import 'routes/app_routes.dart';
import 'firebase/firebase_initializer.dart';
import 'firebase/firebase_providers.dart';
import 'screens/auth_gate.dart';  // <-- Importa el nuevo widget

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final connected = await initializeFirebaseAndMessaging();

  if (connected) {
    await PushNotificationService.initialize(); // Inicializa notificaciones push
  }

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'TutorConnect',
          debugShowCheckedModeBanner: false,
          // eliminamos initialRoute y onGenerateRoute para delegar a AuthGate
          home: const AuthGate(),
          onGenerateRoute: AppRoutes.generateRoute,
          theme: ThemeData(
            // Definimos un tema claro con texto negro por defecto
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

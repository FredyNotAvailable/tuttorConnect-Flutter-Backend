import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/user_service.dart'; // Asegúrate de importar correctamente

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Iniciar sesión con email y contraseña y actualizar token FCM
  Future<User?> signInWithEmailPassword(
    String email,
    String password,
    UserService userService,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user;

      if (fbUser != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          final currentUser = await userService.getUserById(fbUser.uid);

          if (currentUser == null) {
            // Usuario no encontrado, lanzar excepción o manejar error
            throw Exception('Usuario con ID ${fbUser.uid} no encontrado en la base de datos.');
          }

          if (currentUser.fcmToken != fcmToken) {
            final updatedUser = currentUser.copyWith(fcmToken: fcmToken);
            await userService.updateUser(updatedUser);
          }
        }
      }
      return fbUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

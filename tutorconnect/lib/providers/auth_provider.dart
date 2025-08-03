// auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../services/auth_service.dart';
import '../providers/user_provider.dart' as user_prov;

/// Proveedor del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  print('[authServiceProvider] → Instanciando AuthService');
  return AuthService();
});

/// Proveedor de stream que escucha los cambios en la autenticación
final authStateProvider = StreamProvider<fb_auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  print('[authStateProvider] → Escuchando authStateChanges');

  return authService.authStateChanges.map((user) {
    if (user != null) {
      print('[authStateProvider] → Usuario autenticado: ${user.uid}');
    } else {
      print('[authStateProvider] → Usuario no autenticado');
    }
    return user;
  });
});

/// Proveedor para iniciar sesión con email y contraseña
final signInProvider = FutureProvider.family<fb_auth.User?, Map<String, String>>(
  (ref, credentials) async {
    final authService = ref.watch(authServiceProvider);
    final userService = ref.watch(user_prov.userServiceProvider);

    final email = credentials['email'] ?? '';
    final password = credentials['password'] ?? '';

    print('[signInProvider] → Intentando login con email: $email');

    final user = await authService.signInWithEmailPassword(
      email,
      password,
      userService,
    );

    if (user != null) {
      print('[signInProvider] → Login exitoso, UID: ${user.uid}');
    } else {
      print('[signInProvider] → Login fallido');
    }

    return user;
  },
);

/// Proveedor para cerrar sesión
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  print('[signOutProvider] → Cerrando sesión');
  await authService.signOut();
  print('[signOutProvider] → Sesión cerrada');
});

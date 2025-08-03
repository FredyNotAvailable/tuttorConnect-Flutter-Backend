// user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:tutorconnect/data/firebase_user_datasource.dart';
import 'package:tutorconnect/providers/auth_provider.dart';
import 'package:tutorconnect/repositories/user/user_repository.dart';
import 'package:tutorconnect/repositories/user/user_repository_impl.dart';
import 'package:tutorconnect/services/user_service.dart';
import 'package:tutorconnect/models/user.dart';

/// 1. Proveedor del DataSource concreto
final firebaseUserDataSourceProvider = Provider<FirebaseUserDataSource>((ref) {
  return FirebaseUserDataSource();
});

/// 2. Proveedor del Repositorio que usa el DataSource
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.read(firebaseUserDataSourceProvider);
  return UserRepositoryImpl(dataSource: dataSource);
});

/// 3. Proveedor del Service que usa el Repositorio
final userServiceProvider = Provider<UserService>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserService(repository);
});

/// 4. StateNotifier para manejar lista de usuarios y acciones
class UserNotifier extends StateNotifier<List<User>> {
  final UserService _service;

  UserNotifier(this._service) : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    final users = await _service.getAllUsers();
    // ignore: avoid_print
    print('Users loaded: ${users.length}');
    state = users;
  }

  Future<void> updateUser(User user) async {
    await _service.updateUser(user);
    await loadUsers();
  }

  Future<User?> getUserById(String id) async {
    return await _service.getUserById(id);
  }
}

/// 5. Proveedor del StateNotifier que expone lista de usuarios
final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final service = ref.read(userServiceProvider);
  return UserNotifier(service);
});

/// 6. Provider que devuelve el usuario actual individual según el usuario autenticado en Firebase
final currentUserProvider = FutureProvider<User?>((ref) async {
  final fb_auth.User? firebaseUser = ref.watch(authStateProvider).value;

  if (firebaseUser == null) {
    // No hay usuario autenticado
    return null;
  }

  final userService = ref.read(userServiceProvider);

  // Obtener el usuario completo desde BD según UID Firebase
  final user = await userService.getUserById(firebaseUser.uid);

  return user;
});

final userByIdProvider = FutureProvider.family<User?, String>((ref, userId) async {
  // Usar directamente el servicio para no depender del estado de la lista completa
  final userService = ref.read(userServiceProvider);
  return await userService.getUserById(userId);
});

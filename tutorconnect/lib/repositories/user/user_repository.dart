// user_repository.dart

import '../../models/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);

  Future<List<User>> getAllUsers();

  Future<void> updateUser(User user);
}

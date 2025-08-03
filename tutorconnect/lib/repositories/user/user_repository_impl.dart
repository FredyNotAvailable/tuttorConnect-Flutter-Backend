// user_repository_impl.dart

import 'package:tutorconnect/data/firebase_user_datasource.dart';

import '../../models/user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<User?> getUserById(String id) {
    return dataSource.getUserById(id);
  }

  @override
  Future<List<User>> getAllUsers() {
    return dataSource.getAllUsers();
  }

  @override
  Future<void> updateUser(User user) {
    return dataSource.updateUser(user);
  }
}

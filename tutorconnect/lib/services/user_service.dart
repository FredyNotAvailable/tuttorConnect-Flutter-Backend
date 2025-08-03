//user_service.dart

import 'package:tutorconnect/repositories/user/user_repository.dart';
import '../models/user.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<User?> getUserById(String id) async {
    return await _userRepository.getUserById(id);
  }

  Future<List<User>> getAllUsers() async {
    return await _userRepository.getAllUsers();
  }

  Future<void> updateUser(User user) async {
    await _userRepository.updateUser(user);
  }
}

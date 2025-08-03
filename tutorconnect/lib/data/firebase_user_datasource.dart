// firebase_user_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseUserDataSource {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final logger = Logger();

  Future<User?> getUserById(String id) async {
    try {
      final doc = await usersCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Usuario encontrado: ID=$id');
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe documento para ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener usuario', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener usuario: $e');
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await usersCollection.get();
      final users = querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Usuarios cargados: ${users.length}');
      return users;
    } catch (e, stackTrace) {
      logger.e('Error al obtener usuarios', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar usuarios: $e');
      return [];
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await usersCollection.doc(user.id).update(user.toMap());
      Fluttertoast.showToast(msg: 'Usuario actualizado: ID=${user.id}');
    } catch (e, stackTrace) {
      logger.e('Error al actualizar usuario', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al actualizar usuario: $e');
    }
  }
}

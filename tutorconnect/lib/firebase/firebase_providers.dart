import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

final firebaseConnectedProvider = StreamProvider<bool>((ref) async* {
  // Emitimos true cuando Firebase está inicializado correctamente
  try {
    await Firebase.initializeApp();
    yield true;
  } catch (e) {
    yield false;
  }
});

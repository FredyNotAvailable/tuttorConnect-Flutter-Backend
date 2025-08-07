import 'package:flutter/material.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/screens/home_screen.dart';
import 'package:tutorconnect/screens/profile_screen.dart';
import 'package:tutorconnect/screens/subject_details_screen.dart';
import 'package:tutorconnect/screens/teacher/crear_tutoria_screen.dart';
import 'package:tutorconnect/screens/tutoring_detail_screen.dart';
import '../screens/login_screen.dart';

// Importa aquí otras pantallas cuando las tengas

class AppRoutes {
  static const login = '/login';
  // Define más rutas estáticas aquí, por ejemplo:
  static const home = '/home';
  static const profile = '/profile';
  static const tutoring = '/tutoring';
  static const createTutoring = '/create-tutoring';
  static const subjectDetails = '/subjectDetails';
  static const register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      // Agrega más casos para otras rutas aquí
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // Profile
      case profile:
        final user = settings.arguments as User?; // o String si solo UID
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Usuario no proporcionado')),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (_) => ProfileScreen(
                    user: user,
                  ));
        }
      // Tutoring
      case tutoring:
        final tutoring = settings.arguments as Tutoring?;
        if (tutoring == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Tutoring not provided')),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => TutoringDetailScreen(tutoring: tutoring),
          );
        }
      // Subjects
      case subjectDetails:
        final subject = settings.arguments as Subject;
        return MaterialPageRoute(
          builder: (_) => SubjectDetailsScreen(subject: subject),
        );

      case createTutoring:
        return MaterialPageRoute(builder: (_) => const CrearTutoriaScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

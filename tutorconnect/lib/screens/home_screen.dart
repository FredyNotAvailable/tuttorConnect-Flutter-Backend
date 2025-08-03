import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/routes/app_routes.dart';
import 'package:tutorconnect/providers/auth_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/notifications_widget.dart';
import 'package:tutorconnect/widgets/tutoring_widget.dart';
import 'package:tutorconnect/widgets/subjects_widget.dart';
import 'package:tutorconnect/widgets/schedule_widget.dart'; // <-- Importa aquí el widget de horarios

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (customUser) {
        if (customUser == null) {
          return const Scaffold(
            body: Center(child: Text('User not found or not logged in')),
          );
        }

        final bool isStudent = customUser.role == UserRole.student;

        // Definir listas dinámicas según rol
        final List<Widget> pages = [
          const TutoringWidget(),
          if (isStudent) const NotificationsWidget(),
          const SubjectsWidget(),
          const ScheduleWidget(),
        ];

        final List<BottomNavigationBarItem> navItems = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutorías',
          ),
          if (isStudent)
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Clases',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horarios',
          ),
        ];

        // Ajustar _selectedIndex si fuera necesario para evitar desbordes
        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('TutorConnect'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Perfil',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.profile, arguments: customUser);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Log Out',
                onPressed: () async {
                  await ref.read(signOutProvider.future);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: navItems,
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}


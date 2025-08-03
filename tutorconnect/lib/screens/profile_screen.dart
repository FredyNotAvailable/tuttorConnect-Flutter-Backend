import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/student/academic_info_widget.dart';
import '../models/user.dart';
import '../providers/enrollment_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final isStudent = user.role == UserRole.student;
    final enrollments = ref.watch(enrollmentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_circle, size: 120, color: Colors.grey),
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 16),
            Text('Email: ${user.email}'),
            const SizedBox(height: 8),
            Text('Nombre: ${user.fullname}'),
            const SizedBox(height: 8),
            Text('Rol: ${user.role.getDisplayName()}'),
            const SizedBox(height: 8),
            Text('Creado en: ${user.createdAt}'),
            const SizedBox(height: 24),

            if (isStudent)
              AcademicInfoWidget(
                enrollments: enrollments,
                userId: user.id,
              ),
          ],
        ),
      ),
    );
  }
}

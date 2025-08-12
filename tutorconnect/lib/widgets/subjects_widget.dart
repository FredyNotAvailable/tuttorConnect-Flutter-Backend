import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/routes/app_routes.dart';

class SubjectsWidget extends ConsumerWidget {
  const SubjectsWidget({super.key});

  static const primaryColor = Color.fromRGBO(49, 39, 79, 1);
  static const accentColor = Color.fromRGBO(196, 135, 198, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text(
              'No has iniciado sesión.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final subjectsAsync = ref.watch(subjectsByUserProvider(user));

        return subjectsAsync.when(
          data: (subjects) {
            if (subjects.isEmpty) {
              return Center(
                child: Text(
                  'No se encontraron materias.',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor.withOpacity(0.7),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final Subject subject = subjects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  shadowColor: accentColor.withOpacity(0.3),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(
                      subject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.info_outline,
                      color: accentColor,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.subjectDetails,
                        arguments: subject,
                      );
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}

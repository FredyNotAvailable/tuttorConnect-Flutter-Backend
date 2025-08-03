import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/routes/app_routes.dart';

class SubjectsWidget extends ConsumerWidget {
  const SubjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text('User not logged in.'));

        final subjectsAsync = ref.watch(subjectsByUserProvider(user));

        return subjectsAsync.when(
          data: (subjects) {
            if (subjects.isEmpty) return const Center(child: Text('No subjects found.'));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final Subject subject = subjects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(subject.name),
                    trailing: const Icon(Icons.info_outline),
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
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

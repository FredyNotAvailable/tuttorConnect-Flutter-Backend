import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/class_schedule.dart';
import 'package:tutorconnect/models/classroom.dart';
import 'package:tutorconnect/providers/class_schedule_provider.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/classroom_provider.dart';

class ScheduleWidget extends ConsumerWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final schedules = ref.watch(classScheduleProvider);

    return userAsync.when(
      data: (user) {
        final Map<String, List<ClassSchedule>> groupedSchedules = {};
        for (var schedule in schedules) {
          if (schedule.isActive) {
            groupedSchedules.putIfAbsent(schedule.subjectId, () => []).add(schedule);
          }
        }

        if (groupedSchedules.isEmpty) {
          return const Center(child: Text('No hay horarios disponibles.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedSchedules.entries.map((entry) {
              final subjectId = entry.key;
              final subjectAsync = ref.watch(subjectByIdProvider(subjectId));

              return subjectAsync.when(
                data: (subject) {
                  final subjectName = subject?.name ?? 'Materia desconocida';
                  final subjectSchedules = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...subjectSchedules.map((s) {
                        return ListTile(
                          leading: const Icon(Icons.schedule),
                          title: Text(
                            '${ClassSchedule.dayOfWeekToString(s.dayOfWeek)}: ${s.startTime} - ${s.endTime}',
                          ),
                          subtitle: Consumer(
                          builder: (context, ref, _) {
                              final classrooms = ref.watch(classroomProvider);

                              Classroom? classroom;
                              try {
                                classroom = classrooms.firstWhere((a) => a.id == s.classroomId);
                              } catch (e) {
                                classroom = null;
                              }

                              return Text(
                                'Aula: ${classroom?.name ?? 'Desconocida'} - ${classroom?.type.nombreEnEspanol ?? ''}',
                              );
                            },
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const Text('Error al cargar materia'),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

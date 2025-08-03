import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/models/class_schedule.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/providers/class_schedule_provider.dart';
import 'package:tutorconnect/providers/teacher_plan_provider.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/tutoring_request_provider.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/tutoring_card.dart';

class SubjectDetailsScreen extends ConsumerStatefulWidget {
  final Subject subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  ConsumerState<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends ConsumerState<SubjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(classSchedulesBySubjectProvider(widget.subject.id));
      ref.refresh(tutoringsBySubjectProvider(widget.subject.id));
      ref.read(tutoringRequestProvider.notifier).loadTutoringRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    final schedulesAsync = ref.watch(classSchedulesBySubjectProvider(subject.id));
    final tutoringsAsync = ref.watch(tutoringsBySubjectProvider(subject.id));
    final currentUserAsync = ref.watch(currentUserProvider);
    final tutoringRequests = ref.watch(tutoringRequestProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Materia:'),
            Text(subject.name),
            const SizedBox(height: 16),
            const Text('Docente:'),
            ref.watch(teacherPlanBySubjectIdProvider(subject.id)).when(
              data: (plan) {
                if (plan == null) return const Text('Docente no asignado');
                final teacherId = plan.teacherId;
                return ref.watch(userByIdProvider(teacherId)).when(
                  data: (user) => Text(user?.fullname ?? 'Docente desconocido'),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error cargando docente: $e'),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 16),
            const Text('Horarios:'),
            schedulesAsync.when(
              data: (schedules) {
                if (schedules.isEmpty) return const Text('No hay horarios asignados');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: schedules.map((schedule) {
                    final dayName = ClassSchedule.dayOfWeekToString(schedule.dayOfWeek);
                    return Text('$dayName: ${schedule.startTime} - ${schedule.endTime}');
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),
            const Text('Tutorías relacionadas:'),
            const SizedBox(height: 8),
            currentUserAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (currentUser) {
                if (currentUser == null) {
                  return const Text('No estás autenticado.');
                }

                final userRole = currentUser.role;

                return tutoringsAsync.when(
                  data: (tutorings) {
                    List<Tutoring> filteredTutorings;

                    if (userRole == UserRole.student) {
                      final acceptedRequests = tutoringRequests.where((req) =>
                          req.studentId == currentUser.id &&
                          req.status == TutoringRequestStatus.accepted).toList();

                      final acceptedTutoringIds = acceptedRequests.map((r) => r.tutoringId).toSet();

                      filteredTutorings = tutorings.where((t) => acceptedTutoringIds.contains(t.id)).toList();

                      if (filteredTutorings.isEmpty) {
                        return const Text('No tienes tutorías aceptadas para esta materia.');
                      }
                    } else {
                      // Docente: ver todas las tutorías
                      filteredTutorings = tutorings;
                      if (filteredTutorings.isEmpty) {
                        return const Text('No hay tutorías registradas para esta materia.');
                      }
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTutorings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return TutoringCard(tutoring: filteredTutorings[index]);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Error cargando tutorías: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

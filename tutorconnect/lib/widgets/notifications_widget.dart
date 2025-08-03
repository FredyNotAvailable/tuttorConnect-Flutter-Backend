import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/subject.dart';

import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/user.dart';

import 'package:tutorconnect/providers/tutoring_request_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/subject_provider.dart';

class NotificationsWidget extends ConsumerStatefulWidget {
  const NotificationsWidget({super.key});

  @override
  ConsumerState<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends ConsumerState<NotificationsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.read(tutoringRequestProvider.notifier).loadTutoringRequests();
    ref.read(userProvider.notifier).loadUsers();
    ref.read(tutoringProvider.notifier).loadTutorings();
    ref.read(subjectProvider.notifier).loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final tutoringRequests = ref.watch(tutoringRequestProvider);
    final allUsers = ref.watch(userProvider);
    final allTutorings = ref.watch(tutoringProvider);
    final allSubjects = ref.watch(subjectProvider);
    final tutoringRequestNotifier = ref.read(tutoringRequestProvider.notifier);

    return currentUserAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (currentUser) {
        if (currentUser == null) {
          return const Center(child: Text('No estás autenticado.'));
        }

        final myRequests = tutoringRequests
            .where((req) => req.studentId == currentUser.id)
            .toList();

        if (myRequests.isEmpty) {
          return const Center(child: Text('No tienes notificaciones.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myRequests.length,
          itemBuilder: (context, index) {
            final request = myRequests[index];

            Tutoring? tutoring;
            try {
              tutoring = allTutorings.firstWhere((t) => t.id == request.tutoringId);
            } catch (e) {
              tutoring = null;
            }

            if (tutoring == null) {
              return ListTile(title: Text('Tutoría no encontrada'));
            }

            // Acceder a las propiedades de tutoring de forma segura
            final teacherId = tutoring?.teacherId;
            final subjectId = tutoring?.subjectId;

            User? teacher;
            if (teacherId != null) {
              try {
                teacher = allUsers.firstWhere((u) => u.id == teacherId);
              } catch (e) {
                teacher = null;
              }
            }

            if (teacher == null) {
              return ListTile(title: Text('Docente no encontrado'));
            }

            Subject? subject;
            if (subjectId != null) {
              try {
                subject = allSubjects.firstWhere((s) => s.id == subjectId);
              } catch (e) {
                subject = null;
              }
            }

            if (subject == null) {
              return ListTile(title: Text('Materia no encontrada'));
            }


            // El resto igual...
            final timeAgo = _formatTimeAgo(request.sentAt);

            final isPending = request.status == TutoringRequestStatus.pending;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'El docente ${teacher.fullname} de la materia ${subject.name} '
                      'te ha invitado a la tutoría "${tutoring.topic}".',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enviado hace $timeAgo',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 12),

                    if (!isPending) ...[
                      Text(
                        'Estado: ${_statusText(request.status)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: request.status == TutoringRequestStatus.accepted
                              ? Colors.green
                              : Colors.red,
                        ),
                      )
                    ],

                    if (isPending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final updatedRequest = request.copyWith(
                                status: TutoringRequestStatus.rejected,
                                responseAt: DateTime.now(),
                              );
                              await tutoringRequestNotifier.updateTutoringRequest(updatedRequest);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Solicitud rechazada')),
                                );
                              }
                            },
                            child: const Text('Rechazar'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final updatedRequest = request.copyWith(
                                status: TutoringRequestStatus.accepted,
                                responseAt: DateTime.now(),
                              );
                              await tutoringRequestNotifier.updateTutoringRequest(updatedRequest);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Solicitud aceptada')),
                                );
                              }
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );

      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} h';
    } else {
      return '${diff.inDays} d';
    }
  }

  String _statusText(TutoringRequestStatus status) {
    switch (status) {
      case TutoringRequestStatus.pending:
        return 'Pendiente';
      case TutoringRequestStatus.accepted:
        return 'Aceptada';
      case TutoringRequestStatus.rejected:
        return 'Rechazada';
    }
  }
}

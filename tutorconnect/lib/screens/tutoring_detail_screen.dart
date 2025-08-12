// tutoring_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/classroom.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/models/user.dart';

import 'package:tutorconnect/providers/classroom_provider.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/tutoring_request_provider.dart';

import 'package:tutorconnect/widgets/tutoring_request_card.dart';

class TutoringDetailScreen extends ConsumerWidget {
  final Tutoring tutoring;

  const TutoringDetailScreen({
    super.key,
    required this.tutoring,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classrooms = ref.watch(classroomProvider);
    final subjects = ref.watch(subjectProvider);
    final users = ref.watch(userProvider);
    final tutoringRequests = ref.watch(tutoringRequestProvider);

    Classroom? classroom;
    try {
      classroom = classrooms.firstWhere((c) => c.id == tutoring.classroomId);
    } catch (_) {
      classroom = null;
    }

    Subject? subject;
    try {
      subject = subjects.firstWhere((s) => s.id == tutoring.subjectId);
    } catch (_) {
      subject = null;
    }

    User? teacher;
    try {
      teacher = users.firstWhere((u) => u.id == tutoring.teacherId);
    } catch (_) {
      teacher = null;
    }

    final requestsForTutoring =
        tutoringRequests.where((req) => req.tutoringId == tutoring.id).toList();

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final createdFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tutoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _DetailRow(label: 'Tema', value: tutoring.topic),
            _DetailRow(label: 'Materia', value: subject?.name ?? 'Cargando...'),
            _DetailRow(
                label: 'Docente', value: teacher?.fullname ?? 'Cargando...'),
            _DetailRow(label: 'Aula', value: classroom?.name ?? 'Cargando...'),
            _DetailRow(
                label: 'Fecha', value: dateFormatter.format(tutoring.date)),
            _DetailRow(label: 'Hora inicio', value: tutoring.startTime),
            _DetailRow(label: 'Hora fin', value: tutoring.endTime),
            _DetailRow(label: 'Notas', value: tutoring.notes),
            _DetailRow(
                label: 'Estado', value: tutoring.status.name.toUpperCase()),
            _DetailRow(
                label: 'Creado el',
                value: createdFormatter.format(tutoring.createdAt)),
            const SizedBox(height: 16),
            const Text(
              'Solicitudes de Tutoría:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (requestsForTutoring.isEmpty)
              const Text('No hay solicitudes para esta tutoría.')
            else
              ...requestsForTutoring
                  .map((req) => TutoringRequestCard(request: req)),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

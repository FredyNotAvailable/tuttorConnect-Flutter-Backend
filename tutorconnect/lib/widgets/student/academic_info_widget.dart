import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/enrollment.dart';
import 'package:tutorconnect/models/career.dart';
import 'package:tutorconnect/providers/career_provider.dart';

class AcademicInfoWidget extends ConsumerWidget {
  final List<Enrollment> enrollments;
  final String userId;

  const AcademicInfoWidget({
    super.key,
    required this.enrollments,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careers = ref.watch(careerProvider);

    final filtered = enrollments.where((e) => e.studentId == userId && e.isActive);
    final Enrollment? activeEnrollment = filtered.isNotEmpty ? filtered.first : null;

    if (activeEnrollment == null) {
      return const Text('No se encontró matrícula activa.');
    }

    // Buscar carrera por id
    final career = careers.isNotEmpty
        ? careers.firstWhere(
            (c) => c.id == activeEnrollment.careerId,
            orElse: () => Career(
              id: '',
              name: 'Desconocida',
              // completar con valores por defecto para los demás campos si los tiene
            ),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información Académica',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text('Carrera: ${career?.name ?? "Desconocida"}'),
        Text('Ciclo: ${activeEnrollment.cycle}'),
        Text('Estado: ${activeEnrollment.isActive ? "Activo" : "Inactivo"}'),
        Text('Fecha de inscripción: ${activeEnrollment.createdAt}'),
      ],
    );
  }
}

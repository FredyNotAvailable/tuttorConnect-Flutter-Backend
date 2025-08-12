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

  static const primaryColor = Color.fromRGBO(49, 39, 79, 1);
  static const accentColor = Color.fromRGBO(196, 135, 198, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careers = ref.watch(careerProvider);

    final filtered =
        enrollments.where((e) => e.studentId == userId && e.isActive);
    final Enrollment? activeEnrollment =
        filtered.isNotEmpty ? filtered.first : null;

    if (activeEnrollment == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No se encontró matrícula activa.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    // Buscar carrera por id
    final career = careers.isNotEmpty
        ? careers.firstWhere(
            (c) => c.id == activeEnrollment.careerId,
            orElse: () => Career(
              id: '',
              name: 'Desconocida',
            ),
          )
        : null;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Académica',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Carrera', career?.name ?? "Desconocida"),
          _buildInfoRow('Ciclo', '${activeEnrollment.cycle}'),
          _buildInfoRow(
              'Estado', activeEnrollment.isActive ? "Activo" : "Inactivo"),
          _buildInfoRow(
              'Fecha de inscripción', activeEnrollment.createdAt.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/routes/app_routes.dart';

class TutoringCard extends StatelessWidget {
  final Tutoring tutoring;

  const TutoringCard({required this.tutoring, super.key});

  static const primaryColor = Color.fromRGBO(49, 39, 79, 1);
  static const accentColor = Color.fromRGBO(196, 135, 198, 1);

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd/MM/yyyy').format(tutoring.date);
    final statusText = tutoring.status.name.toUpperCase();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.tutoring,
          arguments: tutoring,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // para que no se expanda
          children: [
            Text(
              tutoring.topic,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Fecha', dateFormatted),
            _buildInfoRow(
                'Horario', '${tutoring.startTime} - ${tutoring.endTime}'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Estado: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    color: _statusColor(tutoring.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(TutoringStatus status) {
    switch (status) {
      case TutoringStatus.active:
        return Colors.green.shade700;
      case TutoringStatus.finished:
        return Colors.grey.shade600;
      case TutoringStatus.canceled:
        return Colors.red.shade700;
      default:
        return Colors.black87;
    }
  }
}

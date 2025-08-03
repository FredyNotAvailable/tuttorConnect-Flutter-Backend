import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/routes/app_routes.dart';

class TutoringCard extends StatelessWidget {
  final Tutoring tutoring;

  const TutoringCard({required this.tutoring, super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('yyyy-MM-dd').format(tutoring.date);
    final statusText = tutoring.status.name.toUpperCase();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.tutoring,
          arguments: tutoring,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,  // importante para que el Column no expanda
            children: [
              Text(
                'Topic: ${tutoring.topic}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Date: $dateFormatted',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Time: ${tutoring.startTime} - ${tutoring.endTime}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Status: $statusText',
                style: TextStyle(
                  color: _statusColor(tutoring.status),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(TutoringStatus status) {
    switch (status) {
      case TutoringStatus.active:
        return Colors.green;
      case TutoringStatus.finished:
        return Colors.grey;
      case TutoringStatus.canceled:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

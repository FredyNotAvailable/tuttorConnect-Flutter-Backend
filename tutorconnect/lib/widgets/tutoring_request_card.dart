import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/models/tutoring_attendance.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/tutoring_attendance_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';

class TutoringRequestCard extends ConsumerStatefulWidget {
  final TutoringRequest request;

  const TutoringRequestCard({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<TutoringRequestCard> createState() => _TutoringRequestCardState();
}

class _TutoringRequestCardState extends ConsumerState<TutoringRequestCard> {
  AttendanceStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _syncSelectedStatus();
  }

  @override
  void didUpdateWidget(covariant TutoringRequestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request != widget.request) {
      _syncSelectedStatus();
    }
  }

  void _syncSelectedStatus() {
    final attendances = ref.read(tutoringAttendanceProvider);
    final attendance = _findAttendance(attendances);
    if (_selectedStatus != attendance?.status) {
      setState(() {
        _selectedStatus = attendance?.status;
      });
    }
  }

  TutoringAttendance? _findAttendance(List<TutoringAttendance> attendances) {
    try {
      return attendances.firstWhere(
        (a) =>
            a.studentId == widget.request.studentId &&
            a.tutoriaId == widget.request.tutoringId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _onStatusChanged(AttendanceStatus? newStatus) async {
    if (newStatus == null) return;

    setState(() {
      _selectedStatus = newStatus;
    });

    final attendanceNotifier = ref.read(tutoringAttendanceProvider.notifier);
    final attendances = ref.read(tutoringAttendanceProvider);
    final existingAttendance = _findAttendance(attendances);

    if (existingAttendance != null) {
      final updatedAttendance = TutoringAttendance(
        id: existingAttendance.id,
        date: existingAttendance.date,
        status: newStatus,
        studentId: existingAttendance.studentId,
        tutoriaId: existingAttendance.tutoriaId,
      );
      await attendanceNotifier.updateAttendance(updatedAttendance);
    } else {
      final newAttendance = TutoringAttendance(
        id: '',
        date: DateTime.now(),
        status: newStatus,
        studentId: widget.request.studentId,
        tutoriaId: widget.request.tutoringId,
      );
      await attendanceNotifier.addAttendance(newAttendance);
    }
  }

  Widget buildAttendanceWidget(bool isTeacher) {
    if (widget.request.status != TutoringRequestStatus.accepted) {
      return const Text(
        'Asistencia: No disponible - estado no aceptado',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    if (isTeacher) {
      return Row(
        children: [
          const Text(
            'Asistencia: ',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<AttendanceStatus?>(
              isExpanded: true,
              value: _selectedStatus,
              items: [
                const DropdownMenuItem<AttendanceStatus?>(
                  value: null,
                  child: Text('Seleccione...'),
                ),
                ...AttendanceStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      TutoringAttendance.statusToStringSpanish(status),
                    ),
                  );
                }).toList(),
              ],
              onChanged: (newStatus) {
                if (newStatus != null) {
                  _onStatusChanged(newStatus);
                }
              },
            ),
          ),
        ],
      );
    } else {
      return Text(
        'Asistencia: ${_selectedStatus != null ? TutoringAttendance.statusToStringSpanish(_selectedStatus!) : "No registrada"}',
        style: const TextStyle(fontSize: 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendances = ref.watch(tutoringAttendanceProvider);
    final attendance = _findAttendance(attendances);

    if (_selectedStatus != attendance?.status) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedStatus = attendance?.status;
          });
        }
      });
    }

    final firebaseUserAsync = ref.watch(currentUserProvider);

    return firebaseUserAsync.when(
      data: (currentUserModel) {
        final users = ref.watch(userProvider);
        final isTeacher = currentUserModel?.role == UserRole.teacher;

        print('DEBUG: Usuario actual: ${currentUserModel?.fullname}');
        print('DEBUG: Rol: ${currentUserModel?.role}');
        print('DEBUG: ¿Es docente?: $isTeacher');
        print('DEBUG: Estado de la solicitud: ${widget.request.status}');

        User? student;
        try {
          student = users.firstWhere((u) => u.id == widget.request.studentId);
        } catch (e) {
          student = null;
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student != null ? student.fullname : 'Estudiante desconocido',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estado solicitud: ${TutoringRequestUtils.statusToSpanish(widget.request.status)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                buildAttendanceWidget(isTeacher),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

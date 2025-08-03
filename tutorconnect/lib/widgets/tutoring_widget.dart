import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/tutoring_request_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/tutoring_card.dart';
import 'package:tutorconnect/routes/app_routes.dart';

class TutoringWidget extends ConsumerStatefulWidget {
  const TutoringWidget({super.key});

  @override
  ConsumerState<TutoringWidget> createState() => _TutoringWidgetState();
}

class _TutoringWidgetState extends ConsumerState<TutoringWidget> {
  bool _loading = true;
  String? _error;
  UserRole? _currentUserRole;
  List<TutoringRequest> _studentTutoringRequests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) {
        setState(() {
          _error = 'No se encontró el usuario autenticado.';
          _loading = false;
        });
        return;
      }

      setState(() {
        _currentUserRole = user.role;
      });

      final tutoringNotifier = ref.read(tutoringProvider.notifier);
      final subjectNotifier = ref.read(subjectProvider.notifier);

      // Cargar materias para el usuario
      await subjectNotifier.loadSubjectsByUser(user);

      if (user.role == UserRole.teacher) {
        await tutoringNotifier.loadTutoringsByTeacherId(user.id);
      } else if (user.role == UserRole.student) {
        final tutoringRequestNotifier = ref.read(tutoringRequestProvider.notifier);
        _studentTutoringRequests = await tutoringRequestNotifier.getTutoringRequestsByStudentId(user.id);

        final tutoringRequestIds = _studentTutoringRequests.map((r) => r.id).toList();
        await tutoringNotifier.loadTutoringsByTutoringRequestIds(tutoringRequestIds);
      } else {
        setState(() {
          _error = 'Rol de usuario no válido.';
          _loading = false;
        });
        return;
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos: $e';
        _loading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  final tutorings = ref.watch(tutoringProvider);
  final subjects = ref.watch(subjectProvider);

  // Filtrar tutorías para estudiantes según solicitudes aceptadas
  List<Tutoring> filteredTutorings = tutorings;
  if (_currentUserRole == UserRole.student) {
    final acceptedTutoringIds = _studentTutoringRequests
        .where((req) => req.status == TutoringRequestStatus.accepted)
        .map((req) => req.tutoringId)
        .toSet();

    filteredTutorings = tutorings.where((t) => acceptedTutoringIds.contains(t.id)).toList();
  }

  // Agrupar tutorías por subjectId
  final Map<String, List<Tutoring>> tutoringsBySubject = {};
  for (var t in filteredTutorings) {
    tutoringsBySubject.putIfAbsent(t.subjectId, () => []).add(t);
  }

  return Scaffold(
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Text(_error!))
            : tutoringsBySubject.isEmpty
                ? const Center(child: Text('No hay tutorías disponibles.'))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: tutoringsBySubject.entries.expand((entry) {
                      final subjectId = entry.key;
                      final subjectTutorings = entry.value;
                      Subject? subject;
                      try {
                        subject = subjects.firstWhere((s) => s.id == subjectId);
                      } catch (e) {
                        subject = null;
                      }

                      return [
                        Text(
                          subject?.name ?? 'Materia desconocida',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...subjectTutorings.map((tutoring) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TutoringCard(tutoring: tutoring),
                            )),
                        const SizedBox(height: 24),
                      ];
                    }).toList(),
                  ),
    floatingActionButton: (_currentUserRole == UserRole.teacher)
        ? FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.createTutoring);
              setState(() {
                _loading = true;
              });
              _loadData();
            },
            tooltip: 'Crear tutoría',
            child: const Icon(Icons.add),
          )
        : null,
  );
}


}

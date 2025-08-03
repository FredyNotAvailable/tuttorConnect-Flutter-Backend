import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/career.dart';
import 'package:tutorconnect/models/subject_enrollment.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/models/teacher_plan.dart';
import 'package:tutorconnect/providers/career_provider.dart';
import 'package:tutorconnect/providers/classroom_provider.dart';
import 'package:tutorconnect/providers/subject_enrollment_provider.dart';
import 'package:tutorconnect/providers/subject_provider.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/tutoring_request_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/providers/teacher_plan_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart'; // Ajusta la ruta si es necesario

class CrearTutoriaScreen extends ConsumerStatefulWidget {
  const CrearTutoriaScreen({super.key});

  @override
  ConsumerState<CrearTutoriaScreen> createState() => _CrearTutoriaScreenState();
}

class _CrearTutoriaScreenState extends ConsumerState<CrearTutoriaScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _classroomId;

  // Variables para dropdown encadenados carrera, ciclo, materia
  String? _selectedCareerId;
  int? _selectedCycle;
  String? _selectedSubjectId;

  String? _careerId;

  List<int> _availableCycles = [];
  List<String> _availableSubjects = [];

  List<String> _studentIds = [];
  List<String> tutoringRequestIds = [];
  String? _teacherId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Cargar el ID del docente actual y sus planes
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      _teacherId = currentUser.id;
      ref.read(teacherPlanProvider.notifier).loadTeacherPlansByTeacherId(_teacherId!);
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final now = TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? now) : (_endTime ?? now),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  void _onCareerChanged(String? careerId, List<TeacherPlan> plans) {
    setState(() {
      _selectedCareerId = careerId;
      _selectedCycle = null;
      _selectedSubjectId = null;
      _availableCycles = [];
      _availableSubjects = [];

      if (careerId != null) {
        final plan = plans.firstWhere((p) => p.careerId == careerId);
        _availableCycles = plan.subjectsByCycle.keys.map(int.parse).toList()..sort();
      }
    });
  }

  void _onCycleChanged(int? cycle, List<TeacherPlan> plans) {
    setState(() {
      _selectedCycle = cycle;
      _selectedSubjectId = null;
      _availableSubjects = [];

      if (_selectedCareerId != null && cycle != null) {
        final plan = plans.firstWhere((p) => p.careerId == _selectedCareerId);
        final subjects = plan.subjectsByCycle[cycle.toString()] ?? [];
        _availableSubjects = subjects;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona fecha y hora.')),
      );
      return;
    }
    if (_classroomId == null || _selectedSubjectId == null || _teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faltan datos necesarios para crear la tutoría.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final createdAt = DateTime.now();

    final tutoring = Tutoring(
      id: '', // Lo asigna Firebase
      classroomId: _classroomId!,
      createdAt: createdAt,
      date: DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day),
      startTime: _startTime!.format(context),
      endTime: _endTime!.format(context),
      notes: _notesController.text.trim(),
      status: TutoringStatus.active,
      tutoringRequestIds: [], // Inicialmente vacío
      subjectId: _selectedSubjectId!,
      teacherId: _teacherId!,
      topic: _topicController.text.trim(),
    );

    try {
      final createdTutoring = await ref.read(tutoringProvider.notifier).addTutoring(tutoring);

      if (createdTutoring == null) {
        throw Exception('Error al crear la tutoría');
      }

      // Crear solicitudes para cada estudiante
      List<String> createdRequestIds = [];

      for (final studentId in _studentIds) {
        final request = TutoringRequest(
          id: '', // será asignado por Firestore
          tutoringId: createdTutoring.id,
          studentId: studentId,
          status: TutoringRequestStatus.pending,
          sentAt: DateTime.now(),
          responseAt: null,
        );

        final createdRequest = await ref.read(tutoringRequestProvider.notifier).addTutoringRequest(request);
        if (createdRequest != null) {
          createdRequestIds.add(createdRequest.id);
        }
      }

      // Actualizar la tutoría con los IDs de solicitudes creadas
      final updatedTutoring = createdTutoring.copyWith(tutoringRequestIds: createdRequestIds);
      await ref.read(tutoringProvider.notifier).updateTutoring(updatedTutoring);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutoría creada exitosamente')),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear tutoría: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final classrooms = ref.watch(classroomProvider);
    final teacherPlans = ref.watch(teacherPlanProvider);
    final careers = ref.watch(careerProvider);
    final subjects = ref.watch(subjectProvider);
    final allEnrollments = ref.watch(subjectEnrollmentProvider);
    final inProgress = allEnrollments
        .where((e) => e.status == SubjectEnrollmentStatus.inProgress) // No poner .name
        .toList();



    final availableSubjectsObjects = subjects
    .where((subject) => _availableSubjects.contains(subject.id))
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Tutoría'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Barra simple con botón atrás
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Crear Tutoría',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Tema
                        TextFormField(
                          controller: _topicController,
                          decoration: const InputDecoration(labelText: 'Tema'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El tema es obligatorio';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Notas
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(labelText: 'Notas (opcional)'),
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                        ),

                        const SizedBox(height: 12),

                        // Dropdown Carrera
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Carrera'),
                          items: teacherPlans.isEmpty
                              ? [
                                  const DropdownMenuItem(value: null, child: Text('No hay carreras disponibles')),
                                ]
                              : teacherPlans
                                  .map((plan) => plan.careerId)
                                  .toSet()
                                  .map((careerId) {
                                    final careerName = careers.firstWhere(
                                      (career) => career.id == careerId,
                                      orElse: () => Career(id: '', name: careerId), // fallback por si no encuentra
                                    ).name;
                                    return DropdownMenuItem(
                                      value: careerId,
                                      child: Text(careerName),
                                    );
                                  }).toList(),
                          value: _selectedCareerId,
                          onChanged: (value) => _onCareerChanged(value, teacherPlans),
                          validator: (value) => value == null ? 'Selecciona una carrera' : null,
                        ),

                        const SizedBox(height: 12),

                        // Dropdown Ciclo
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Ciclo'),
                          items: _availableCycles.isEmpty
                              ? [
                                  const DropdownMenuItem(value: null, child: Text('Selecciona carrera primero')),
                                ]
                              : _availableCycles
                                  .map((cycle) => DropdownMenuItem(
                                        value: cycle,
                                        child: Text('Ciclo $cycle'),
                                      ))
                                  .toList(),
                          value: _selectedCycle,
                          onChanged: _availableCycles.isEmpty ? null : (value) => _onCycleChanged(value, teacherPlans),
                          validator: (value) => value == null ? 'Selecciona un ciclo' : null,
                        ),

                        const SizedBox(height: 12),

                        // Dropdown Materia
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Materia'),
                          items: availableSubjectsObjects.isEmpty
                              ? [
                                  const DropdownMenuItem(value: null, child: Text('Selecciona ciclo primero')),
                                ]
                              : availableSubjectsObjects.map((subject) => DropdownMenuItem(
                                    value: subject.id,
                                    child: Text(subject.name),
                                  )).toList(),
                          value: _selectedSubjectId,
                          onChanged: availableSubjectsObjects.isEmpty
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedSubjectId = value;
                                });
                              },
                          validator: (value) => value == null ? 'Selecciona una materia' : null,
                        ),

                        const SizedBox(height: 12),

                        Builder(
                          builder: (context) {
                            if (_selectedSubjectId == null) {
                              _studentIds = [];
                              return const SizedBox();
                            }

                            final inProgressEnrollments = inProgress.where((e) => e.subjectId == _selectedSubjectId).toList();

                            if (inProgressEnrollments.isEmpty) {
                              _studentIds = [];
                              return const Text('No hay estudiantes inscritos con estado "En progreso" para esta materia.');
                            }

                            final allUsers = ref.watch(userProvider);
                            final estudiantes = allUsers.where((u) =>
                              u.role == UserRole.student &&
                              inProgressEnrollments.any((enrollment) => enrollment.studentId == u.id)
                            ).toList();

                            // *** Aquí es el lugar correcto para asignar la lista de IDs ***
                            _studentIds = estudiantes.map((e) => e.id).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Estudiantes inscritos (En progreso):',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...estudiantes.map((e) => ListTile(
                                      title: Text(e.fullname),
                                      subtitle: Text(e.email),
                                      leading: const Icon(Icons.person_outline),
                                    )),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),



                        // Selector Aula dinámico
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Aula'),
                          items: classrooms.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('No hay aulas disponibles'),
                                  )
                                ]
                              : classrooms
                                  .map(
                                    (aula) => DropdownMenuItem(
                                      value: aula.id,
                                      child: Text('${aula.name} - ${aula.type.name}'),
                                    ),
                                  )
                                  .toList(),
                          onChanged: classrooms.isEmpty ? null : (value) => setState(() => _classroomId = value),
                          value: classrooms.any((a) => a.id == _classroomId) ? _classroomId : null,
                          validator: (value) => value == null ? 'Selecciona un aula' : null,
                        ),

                        const SizedBox(height: 12),

                        // Fecha
                        Row(
                          children: [
                            const Text('Fecha: '),
                            TextButton(
                              onPressed: _pickDate,
                              child: Text(_selectedDate == null
                                  ? 'Seleccionar fecha'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                            ),
                          ],
                        ),

                        // Hora inicio
                        Row(
                          children: [
                            const Text('Hora inicio: '),
                            TextButton(
                              onPressed: () => _pickTime(isStart: true),
                              child: Text(_startTime == null ? 'Seleccionar hora' : _startTime!.format(context)),
                            ),
                          ],
                        ),

                        // Hora fin
                        Row(
                          children: [
                            const Text('Hora fin: '),
                            TextButton(
                              onPressed: () => _pickTime(isStart: false),
                              child: Text(_endTime == null ? 'Seleccionar hora' : _endTime!.format(context)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const CircularProgressIndicator()
                              : const Text('Crear Tutoría'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class ClassSchedule {
  final String id;
  final String classroomId;
  final DayOfWeek dayOfWeek;
  final String startTime; // formato "HH:mm"
  final String endTime;   // formato "HH:mm"
  final bool isActive;
  final String subjectId;
  final String teacherId;

  ClassSchedule({
    required this.id,
    required this.classroomId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.subjectId,
    required this.teacherId,
  });

  factory ClassSchedule.fromMap(Map<String, dynamic> map, String documentId) {
    return ClassSchedule(
      id: documentId,
      classroomId: map['classroomId'] ?? '',
      dayOfWeek: _stringToDayOfWeek(map['dayOfWeek'] ?? 'monday'),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      isActive: map['isActive'] ?? true,
      subjectId: map['subjectId'] ?? '',
      teacherId: map['teacherId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'dayOfWeek': _dayOfWeekToString(dayOfWeek),
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
      'subjectId': subjectId,
      'teacherId': teacherId,
    };
  }

  static DayOfWeek _stringToDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DayOfWeek.monday;
      case 'tuesday':
        return DayOfWeek.tuesday;
      case 'wednesday':
        return DayOfWeek.wednesday;
      case 'thursday':
        return DayOfWeek.thursday;
      case 'friday':
        return DayOfWeek.friday;
      case 'saturday':
        return DayOfWeek.saturday;
      case 'sunday':
        return DayOfWeek.sunday;
      default:
        return DayOfWeek.monday; // valor por defecto
    }
  }

  static String _dayOfWeekToString(DayOfWeek day) {
    return day.toString().split('.').last;
  }

  static String dayOfWeekToString(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return 'Lunes';
      case DayOfWeek.tuesday:
        return 'Martes';
      case DayOfWeek.wednesday:
        return 'Miércoles';
      case DayOfWeek.thursday:
        return 'Jueves';
      case DayOfWeek.friday:
        return 'Viernes';
      case DayOfWeek.saturday:
        return 'Sábado';
      case DayOfWeek.sunday:
        return 'Domingo';
    }
  }
}

enum UserRole { student, teacher }

extension UserRoleExtension on UserRole {
  String toShortString() => toString().split('.').last;

  static UserRole fromString(String value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      default:
        throw ArgumentError('Rol inválido: $value');
    }
  }

  String getDisplayName() {
    switch (this) {
      case UserRole.student:
        return 'Estudiante';
      case UserRole.teacher:
        return 'Docente';
    }
  }
}
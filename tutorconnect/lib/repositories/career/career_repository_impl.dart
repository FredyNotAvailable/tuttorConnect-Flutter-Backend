import 'package:tutorconnect/data/firebase_career_datasource.dart';

import '../../models/career.dart';
import 'career_repository.dart';

class CareerRepositoryImpl implements CareerRepository {
  final FirebaseCareerDataSource dataSource;

  CareerRepositoryImpl({required this.dataSource});

  @override
  Future<Career?> getCareerById(String id) {
    return dataSource.getCareerById(id);
  }

  @override
  Future<List<Career>> getAllCareers() {
    return dataSource.getAllCareers();
  }
}

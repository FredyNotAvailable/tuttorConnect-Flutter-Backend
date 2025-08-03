import '../../models/career.dart';

abstract class CareerRepository {
  Future<Career?> getCareerById(String id);

  Future<List<Career>> getAllCareers();
}

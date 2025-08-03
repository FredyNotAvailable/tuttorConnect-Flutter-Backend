import 'package:tutorconnect/repositories/career/career_repository.dart';
import '../models/career.dart';

class CareerService {
  final CareerRepository _careerRepository;

  CareerService(this._careerRepository);

  Future<Career?> getCareerById(String id) async {
    return await _careerRepository.getCareerById(id);
  }

  Future<List<Career>> getAllCareers() async {
    return await _careerRepository.getAllCareers();
  }
}

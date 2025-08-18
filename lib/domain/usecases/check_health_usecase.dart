import 'package:legion/domain/repositories/health_repository.dart';

class CheckHealthUseCase {
  final HealthRepository repo;

  CheckHealthUseCase(this.repo);

  Future<bool> call() => repo.check();
}

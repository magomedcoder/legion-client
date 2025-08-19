import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/domain/repositories/health_repository.dart';

class HealthRepositoryImpl implements HealthRepository {
  final RestApiRemoteDataSource restApiRemoteDataSource;

  HealthRepositoryImpl(this.restApiRemoteDataSource);

  @override
  Future<bool> check() async {
    final h = await restApiRemoteDataSource.getHealth();
    return h.status.toLowerCase() == 'ok';
  }
}

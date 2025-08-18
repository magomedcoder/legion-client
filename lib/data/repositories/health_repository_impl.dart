import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/domain/repositories/health_repository.dart';

class HealthRepositoryImpl implements HealthRepository {
  final RestApiRemoteDataSource ds;

  HealthRepositoryImpl(this.ds);

  @override
  Future<bool> check() async {
    final h = await ds.getHealth();
    return h.status.toLowerCase() == 'ok';
  }
}

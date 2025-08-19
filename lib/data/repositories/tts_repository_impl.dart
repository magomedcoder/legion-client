import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/models/synthesize_dto.dart';
import 'package:legion/domain/repositories/tts_repository.dart';

class TtsRepositoryImpl implements TtsRepository {
  final RestApiRemoteDataSource restApiRemoteDataSource;

  TtsRepositoryImpl(this.restApiRemoteDataSource);

  @override
  Future<String> synthesize(String text) async {
    final r = await restApiRemoteDataSource.synthesize(
      SynthesizeRequestDto(text: text),
    );
    return r.wavBase64;
  }
}

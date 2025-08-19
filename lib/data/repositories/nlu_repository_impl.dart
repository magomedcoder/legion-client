import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/data/models/utterance_dto.dart';
import 'package:legion/domain/repositories/nlu_repository.dart';
import 'package:legion/domain/value_objects.dart';

class NluRepositoryImpl implements NluRepository {
  final RestApiRemoteDataSource restApiRemoteDataSource;

  NluRepositoryImpl(this.restApiRemoteDataSource);

  @override
  Future<ReplyDto> sendUtterance(
    String text, {
    ReplyFormat format = ReplyFormat.saytxt,
  }) async {
    return restApiRemoteDataSource.postUtterance(
      UtteranceRequestDto(text: text, format: format.apiValue),
    );
  }
}

import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/data/models/utterance_dto.dart';
import 'package:legion/domain/repositories/nlu_repository.dart';
import 'package:legion/domain/value_objects.dart';

class NluRepositoryImpl implements NluRepository {
  final RestApiRemoteDataSource ds;

  NluRepositoryImpl(this.ds);

  @override
  Future<ReplyDto> sendUtterance(
    String text, {
    ReplyFormat format = ReplyFormat.saytxt,
  }) async {
    return ds.postUtterance(
      UtteranceRequestDto(text: text, format: format.apiValue),
    );
  }
}

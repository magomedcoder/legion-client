import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/domain/repositories/nlu_repository.dart';
import 'package:legion/domain/value_objects.dart';

class SendUtteranceUseCase {
  final NluRepository repo;

  SendUtteranceUseCase(this.repo);

  Future<ReplyDto> call(
    String text, {
    ReplyFormat format = ReplyFormat.saytxt,
  }) => repo.sendUtterance(text, format: format);
}

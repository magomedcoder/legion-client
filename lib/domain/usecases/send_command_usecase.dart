import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/repositories/chat_repository.dart';
import 'package:legion/domain/value_objects.dart';

class SendCommandUseCase {
  final ChatRepository repo;

  SendCommandUseCase(this.repo);

  Future<Message> call(String text, {ReplyFormat format = ReplyFormat.saytxt}) {
    return repo.sendCommand(text: text, format: format);
  }
}

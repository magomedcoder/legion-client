import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/value_objects.dart';

abstract interface class ChatRepository {
  Future<Message> sendCommand({
    required String text,
    ReplyFormat format = ReplyFormat.saytxt,
  });
}

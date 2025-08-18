import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/domain/value_objects.dart';

abstract interface class NluRepository {
  Future<ReplyDto> sendUtterance(String text, {ReplyFormat format});
}

import 'dart:async';

import 'package:legion/core/failures.dart';
import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/data/models/command_dto.dart';
import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/repositories/chat_repository.dart';
import 'package:legion/domain/value_objects.dart';
import 'package:uuid/v4.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RestApiRemoteDataSource restApiRemoteDataSource;
  final WsRemoteDataSource wsRemoteDataSource;
  final _uuid = const UuidV4();

  ChatRepositoryImpl(this.restApiRemoteDataSource, this.wsRemoteDataSource);

  @override
  Future<Message> sendCommand({
    required String text,
    ReplyFormat format = ReplyFormat.saytxt,
  }) async {
    try {
      final dto = await restApiRemoteDataSource.postCommands(
        CommandRequestDto(text: text, format: format.apiValue),
      );
      return Message(
        id: _uuid.generate(),
        author: MessageAuthor.assistant,
        text: dto.text,
        wavBase64: dto.wavBase64,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw NetworkFailure('ChatRepositoryImpl - sendCommand: $e');
    }
  }
}

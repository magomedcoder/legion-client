import 'dart:convert';

import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/domain/repositories/ws_utterance_repository.dart';

class WsUtteranceRepositoryImpl implements WsUtteranceRepository {
  final WsRemoteDataSource ws;

  WsUtteranceRepositoryImpl(this.ws);

  @override
  Stream connect() => ws.connectUtterances().map((e) {
    if (e is String) return jsonDecode(e);
    return e;
  });

  @override
  void send(String text, {required String format}) =>
      ws.sendText(text, format: format);

  @override
  Future<void> disconnect() => ws.disconnect();
}

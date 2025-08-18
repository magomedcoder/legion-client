import 'dart:convert';

import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/domain/repositories/ws_command_repository.dart';

class WsCommandRepositoryImpl implements WsCommandRepository {
  final WsRemoteDataSource ws;

  WsCommandRepositoryImpl(this.ws);

  @override
  Stream connect() => ws.connectCommands().map((e) {
    if (e is String) return jsonDecode(e);
    return e;
  });

  @override
  void send(String text, {required String format}) =>
      ws.sendText(text, format: format);

  @override
  Future<void> disconnect() => ws.disconnect();
}

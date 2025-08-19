import 'dart:convert';

import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/domain/repositories/ws_command_repository.dart';

class WsCommandRepositoryImpl implements WsCommandRepository {
  final WsRemoteDataSource wsRemoteDataSource;

  WsCommandRepositoryImpl(this.wsRemoteDataSource);

  @override
  Stream connect() => wsRemoteDataSource.connectCommands().map((e) {
    if (e is String) return jsonDecode(e);
    return e;
  });

  @override
  void send(String text, {required String format}) =>
      wsRemoteDataSource.sendText(text, format: format);

  @override
  Future<void> disconnect() => wsRemoteDataSource.disconnect();
}

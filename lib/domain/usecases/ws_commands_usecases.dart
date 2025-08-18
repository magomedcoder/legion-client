import 'dart:async';

import 'package:legion/domain/repositories/ws_command_repository.dart';

class ConnectWsCommandsUseCase {
  final WsCommandRepository repo;

  ConnectWsCommandsUseCase(this.repo);

  Stream<Map<String, dynamic>> call() =>
      repo.connect().cast<Map<String, dynamic>>();
}

class SendWsCommandUseCase {
  final WsCommandRepository repo;

  SendWsCommandUseCase(this.repo);

  void call(String text, {required String format}) =>
      repo.send(text, format: format);
}

class DisconnectWsCommandsUseCase {
  final WsCommandRepository repo;

  DisconnectWsCommandsUseCase(this.repo);

  Future<void> call() => repo.disconnect();
}

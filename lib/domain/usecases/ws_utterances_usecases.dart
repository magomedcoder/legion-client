import 'package:legion/domain/repositories/ws_utterance_repository.dart';

class ConnectWsUtterancesUseCase {
  final WsUtteranceRepository repo;

  ConnectWsUtterancesUseCase(this.repo);

  Stream<Map<String, dynamic>> call() =>
      repo.connect().cast<Map<String, dynamic>>();
}

class SendWsUtteranceUseCase {
  final WsUtteranceRepository repo;

  SendWsUtteranceUseCase(this.repo);

  void call(String text, {required String format}) =>
      repo.send(text, format: format);
}

class DisconnectWsUtterancesUseCase {
  final WsUtteranceRepository repo;

  DisconnectWsUtterancesUseCase(this.repo);

  Future<void> call() => repo.disconnect();
}

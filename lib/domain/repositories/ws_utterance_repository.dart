abstract interface class WsUtteranceRepository {
  Stream<dynamic> connect();

  void send(String text, {required String format});

  Future<void> disconnect();
}

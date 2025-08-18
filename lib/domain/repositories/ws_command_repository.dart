typedef WsMessageHandler = void Function(Map<String, dynamic> json);

abstract interface class WsCommandRepository {
  Stream<dynamic> connect();

  void send(String text, {required String format});

  Future<void> disconnect();
}

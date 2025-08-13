import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class IWsRemoteDataSource {
  Stream<dynamic> connectStream();

  void sendBytes(List<int> bytes);

  void sendText(String text, {required String format});

  Future<void> disconnect();
}

class WsRemoteDataSource implements IWsRemoteDataSource {
  WebSocketChannel? _channel;

  @override
  Stream connectStream() {
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://127.0.0.1:8000/ws/asr/stream"),
    );
    return _channel!.stream;
  }

  @override
  void sendBytes(List<int> bytes) {
    _channel!.sink.add(bytes);
  }

  @override
  void sendText(String text, {required String format}) {
    _channel?.sink.add(jsonEncode({'text': text, 'format': format}));
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }
}

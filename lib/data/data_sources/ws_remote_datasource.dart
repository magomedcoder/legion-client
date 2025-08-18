import 'dart:convert';

import 'package:legion/core/env.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class IWsRemoteDataSource {
  Stream<dynamic> connectAsrStream();

  Stream<dynamic> connectCommands();

  Stream<dynamic> connectUtterances();

  void sendBytes(List<int> bytes);

  void sendText(String text, {required String format});

  Future<void> disconnect();
}

class WsRemoteDataSource implements IWsRemoteDataSource {
  WebSocketChannel? _channel;

  @override
  Stream connectAsrStream() {
    _channel = WebSocketChannel.connect(Uri.parse("${Env.ws}/ws/asr/stream"));
    return _channel!.stream;
  }

  @override
  Stream connectCommands() {
    _channel = WebSocketChannel.connect(Uri.parse("${Env.ws}/ws/commands"));
    return _channel!.stream;
  }

  @override
  Stream connectUtterances() {
    _channel = WebSocketChannel.connect(Uri.parse("${Env.ws}/ws/utterances"));
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

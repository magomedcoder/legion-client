import 'package:equatable/equatable.dart';
import 'package:legion/domain/entities/message.dart';

class ChatState extends Equatable {
  final bool wsConnected;
  final bool isRecording;
  final List<Message> messages;
  final String? wavBase64;
  final String? error;

  const ChatState({
    this.wsConnected = false,
    this.isRecording = false,
    this.messages = const [],
    this.wavBase64,
    this.error,
  });

  ChatState copyWith({
    bool? wsConnected,
    bool? isRecording,
    List<Message>? messages,
    String? wavBase64,
    String? error,
  }) => ChatState(
    wsConnected: wsConnected ?? this.wsConnected,
    isRecording: isRecording ?? this.isRecording,
    messages: messages ?? this.messages,
    wavBase64: wavBase64 ?? this.wavBase64,
    error: error,
  );

  @override
  List<Object?> get props => [
    wsConnected,
    isRecording,
    messages,
    wavBase64,
    error,
  ];
}

import 'package:equatable/equatable.dart';
import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/entities/voice_result.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MicVoice extends ChatEvent {}

class ChatSendTextPressed extends ChatEvent {
  final String text;

  ChatSendTextPressed(this.text);

  @override
  List<Object?> get props => [text];
}

class ChatHealthCheckRequested extends ChatEvent {}

class ChatSynthesizeRequested extends ChatEvent {
  final String text;

  ChatSynthesizeRequested(this.text);

  @override
  List<Object?> get props => [text];
}

class ChatUtteranceSendPressed extends ChatEvent {
  final String text;
  final String format;

  ChatUtteranceSendPressed(this.text, this.format);

  @override
  List<Object?> get props => [text, format];
}

class ChatWsCommandsConnect extends ChatEvent {}

class ChatWsCommandsDisconnect extends ChatEvent {}

class ChatWsCommandsSend extends ChatEvent {
  final String text;
  final String format;

  ChatWsCommandsSend(this.text, this.format);

  @override
  List<Object?> get props => [text, format];
}

class ChatWsUtterancesConnect extends ChatEvent {}

class ChatWsUtterancesDisconnect extends ChatEvent {}

class ChatWsUtterancesSend extends ChatEvent {
  final String text;
  final String format;

  ChatWsUtterancesSend(this.text, this.format);

  @override
  List<Object?> get props => [text, format];
}

class ChatWsInternalAddMessage extends ChatEvent {
  final Message msg;

  ChatWsInternalAddMessage(this.msg);

  @override
  List<Object?> get props => [msg];
}

class ChatWsInternalError extends ChatEvent {
  final String err;

  ChatWsInternalError(this.err);

  @override
  List<Object?> get props => [err];
}

class ChatMicFrameReceived extends ChatEvent {
  final VoiceResult result;

  ChatMicFrameReceived(this.result);

  @override
  List<Object?> get props => [result];
}

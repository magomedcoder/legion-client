import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MicVoice extends ChatEvent {
  MicVoice();
}

class ChatSendTextPressed extends ChatEvent {
  final String text;

  ChatSendTextPressed(this.text);

  @override
  List<Object?> get props => [text];
}

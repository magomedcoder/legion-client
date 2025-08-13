import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/usecases/send_command_usecase.dart';
import 'package:legion/domain/usecases/start_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/stop_voice_stream_usecase.dart';
import 'package:legion/domain/value_objects.dart';
import 'package:legion/presentation/bloc/chat_event.dart';
import 'package:legion/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StartVoiceStreamUseCase startVoiceStreamUseCase;
  final StopVoiceStreamUseCase stopVoiceStreamUseCase;
  final SendCommandUseCase sendCommandUseCase;

  StreamSubscription<Message>? _wsSub;

  ChatBloc(
    this.startVoiceStreamUseCase,
    this.stopVoiceStreamUseCase,
    this.sendCommandUseCase,
  ) : super(const ChatState()) {
    on<MicVoice>(onMic);
    on<ChatSendTextPressed>(_onSend);
  }

  Future<void> onMic(MicVoice e, Emitter<ChatState> emit) async {
    try {
      if (state.isRecording) {
        await stopVoiceStreamUseCase();
        emit(state.copyWith(isRecording: false));
      } else {
        emit(state.copyWith(isRecording: true));
        await startVoiceStreamUseCase((result) {
          emit(ChatState(isRecording: true, wavBase64: result.wavBase64));
        });
      }
    } catch (e) {
      print("ChatBloc-onMic-$e");
    }
  }

  Future<void> _onSend(ChatSendTextPressed e, Emitter<ChatState> emit) async {
    final userMsg = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      author: MessageAuthor.user,
      text: e.text,
      createdAt: DateTime.now(),
    );
    emit(state.copyWith(messages: [...state.messages, userMsg], error: null));

    try {
      final reply = await sendCommandUseCase(
        e.text,
        format: ReplyFormat.saytxtSaywav,
      );
      emit(state.copyWith(messages: [...state.messages, reply]));
    } catch (err) {
      emit(state.copyWith(error: '$err'));
    }
  }

  @override
  Future<void> close() async {
    await _wsSub?.cancel();
    return super.close();
  }
}

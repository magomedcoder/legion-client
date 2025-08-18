import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/domain/entities/message.dart';
import 'package:legion/domain/usecases/check_health_usecase.dart';
import 'package:legion/domain/usecases/send_command_usecase.dart';
import 'package:legion/domain/usecases/send_utterance_usecase.dart';
import 'package:legion/domain/usecases/start_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/stop_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/synthesize_usecase.dart';
import 'package:legion/domain/usecases/ws_commands_usecases.dart';
import 'package:legion/domain/usecases/ws_utterances_usecases.dart';
import 'package:legion/domain/value_objects.dart';
import 'package:legion/presentation/bloc/chat_event.dart';
import 'package:legion/presentation/bloc/chat_state.dart';
import 'package:uuid/v4.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StartVoiceStreamUseCase startVoiceStreamUseCase;
  final StopVoiceStreamUseCase stopVoiceStreamUseCase;
  final SendCommandUseCase sendCommandUseCase;
  final CheckHealthUseCase checkHealth;
  final SynthesizeUseCase synthesize;
  final SendUtteranceUseCase sendUtterance;
  final ConnectWsCommandsUseCase connectWsCommands;
  final SendWsCommandUseCase sendWsCommand;
  final DisconnectWsCommandsUseCase disconnectWsCommands;
  final ConnectWsUtterancesUseCase connectWsUtterances;
  final SendWsUtteranceUseCase sendWsUtterance;
  final DisconnectWsUtterancesUseCase disconnectWsUtterances;

  final _uuid = const UuidV4();
  StreamSubscription<Map<String, dynamic>>? _wsCmdSub;
  StreamSubscription<Map<String, dynamic>>? _wsUttSub;

  ChatBloc(
    this.startVoiceStreamUseCase,
    this.stopVoiceStreamUseCase,
    this.sendCommandUseCase,
    this.checkHealth,
    this.synthesize,
    this.sendUtterance,
    this.connectWsCommands,
    this.sendWsCommand,
    this.disconnectWsCommands,
    this.connectWsUtterances,
    this.sendWsUtterance,
    this.disconnectWsUtterances,
  ) : super(const ChatState()) {
    on<MicVoice>(_onMic);
    on<ChatSendTextPressed>(_onSendCommandHttp);
    on<ChatHealthCheckRequested>(_onHealth);
    on<ChatSynthesizeRequested>(_onSynthesize);
    on<ChatUtteranceSendPressed>(_onSendUtteranceHttp);
    on<ChatWsCommandsConnect>(_onWsCmdConnect);
    on<ChatWsCommandsDisconnect>(_onWsCmdDisconnect);
    on<ChatWsCommandsSend>(_onWsCmdSend);
    on<ChatWsUtterancesConnect>(_onWsUttConnect);
    on<ChatWsUtterancesDisconnect>(_onWsUttDisconnect);
    on<ChatWsUtterancesSend>(_onWsUttSend);
    on<ChatWsInternalAddMessage>(_onWsInternalAddMessage);
    on<ChatWsInternalError>(_onWsInternalError);
    on<ChatMicFrameReceived>(_onMicFrameReceived);
  }

  Future<void> _onMic(MicVoice e, Emitter<ChatState> emit) async {
    try {
      if (state.isRecording) {
        await stopVoiceStreamUseCase();
        if (!emit.isDone) {
          emit(state.copyWith(isRecording: false, wavBase64: null));
        }
      } else {
        if (!emit.isDone) emit(state.copyWith(isRecording: true));
        await startVoiceStreamUseCase((result) {
          add(ChatMicFrameReceived(result));
        });
      }
    } catch (err) {
      if (!emit.isDone) emit(state.copyWith(error: "ChatBloc-onMic-$err"));
    }
  }

  void _onMicFrameReceived(ChatMicFrameReceived e, Emitter<ChatState> emit) {
    if (emit.isDone) return;

    final msg = [...state.messages];

    if (e.result.heard != null && e.result.heard!.trim().isNotEmpty) {
      msg.add(
        Message(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          author: MessageAuthor.user,
          text: e.result.heard,
          createdAt: DateTime.now(),
        ),
      );
    }

    if ((e.result.text != null && e.result.text!.trim().isNotEmpty) ||
        (e.result.wavBase64 != null && e.result.wavBase64!.isNotEmpty)) {
      msg.add(
        Message(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          author: MessageAuthor.assistant,
          text: e.result.text,
          wavBase64: e.result.wavBase64,
          createdAt: DateTime.now(),
        ),
      );
    }

    emit(
      state.copyWith(
        isRecording: true,
        wavBase64: e.result.wavBase64,
        messages: msg,
      ),
    );
  }

  Future<void> _onSendCommandHttp(
    ChatSendTextPressed e,
    Emitter<ChatState> emit,
  ) async {
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
      emit(state.copyWith(error: 'sendCommand-$err'));
    }
  }

  Future<void> _onHealth(
    ChatHealthCheckRequested e,
    Emitter<ChatState> emit,
  ) async {
    try {
      final ok = await checkHealth();
      emit(state.copyWith(healthy: ok));
    } catch (err) {
      emit(state.copyWith(error: 'health-$err'));
    }
  }

  Future<void> _onSynthesize(
    ChatSynthesizeRequested e,
    Emitter<ChatState> emit,
  ) async {
    try {
      final wav = await synthesize(e.text);
      final msg = Message(
        id: _uuid.generate(),
        author: MessageAuthor.assistant,
        text: null,
        wavBase64: wav,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, msg]));
    } catch (err) {
      emit(state.copyWith(error: 'synthesize-$err'));
    }
  }

  Future<void> _onSendUtteranceHttp(
    ChatUtteranceSendPressed e,
    Emitter<ChatState> emit,
  ) async {
    try {
      final dto = await sendUtterance(e.text, format: ReplyFormat.saytxt);
      final msg = Message(
        id: _uuid.generate(),
        author: MessageAuthor.assistant,
        text: dto.text,
        wavBase64: dto.wavBase64,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, msg]));
    } catch (err) {
      emit(state.copyWith(error: 'utterance-$err'));
    }
  }

  Future<void> _onWsCmdConnect(
    ChatWsCommandsConnect e,
    Emitter<ChatState> emit,
  ) async {
    await _wsCmdSub?.cancel();
    _wsCmdSub = connectWsCommands().listen(
      (json) {
        final msg = Message(
          id: _uuid.generate(),
          author: MessageAuthor.assistant,
          text: json['text'] as String?,
          wavBase64: json['wav_base64'] as String?,
          createdAt: DateTime.now(),
        );
        add(ChatWsInternalAddMessage(msg));
      },
      onError: (err) {
        add(ChatWsInternalError('ws-commands-$err'));
      },
    );
    emit(state.copyWith(wsConnected: true));
  }

  Future<void> _onWsCmdDisconnect(
    ChatWsCommandsDisconnect e,
    Emitter<ChatState> emit,
  ) async {
    await _wsCmdSub?.cancel();
    await disconnectWsCommands();
    emit(state.copyWith(wsConnected: false));
  }

  Future<void> _onWsCmdSend(
    ChatWsCommandsSend e,
    Emitter<ChatState> emit,
  ) async {
    try {
      sendWsCommand(e.text, format: e.format);
      final userMsg = Message(
        id: _uuid.generate(),
        author: MessageAuthor.user,
        text: e.text,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, userMsg]));
    } catch (err) {
      emit(state.copyWith(error: 'ws-cmd-send-$err'));
    }
  }

  Future<void> _onWsUttConnect(
    ChatWsUtterancesConnect e,
    Emitter<ChatState> emit,
  ) async {
    await _wsUttSub?.cancel();
    _wsUttSub = connectWsUtterances().listen(
      (json) {
        final msg = Message(
          id: _uuid.generate(),
          author: MessageAuthor.assistant,
          text: json['text'] as String?,
          wavBase64: json['wav_base64'] as String?,
          createdAt: DateTime.now(),
        );
        add(ChatWsInternalAddMessage(msg));
      },
      onError: (err) {
        add(ChatWsInternalError('ws-utter-$err'));
      },
    );
    emit(state.copyWith(wsConnected: true));
  }

  Future<void> _onWsUttDisconnect(
    ChatWsUtterancesDisconnect e,
    Emitter<ChatState> emit,
  ) async {
    await _wsUttSub?.cancel();
    await disconnectWsUtterances();
    emit(state.copyWith(wsConnected: false));
  }

  Future<void> _onWsUttSend(
    ChatWsUtterancesSend e,
    Emitter<ChatState> emit,
  ) async {
    try {
      sendWsUtterance(e.text, format: e.format);
    } catch (err) {
      emit(state.copyWith(error: 'ws-utt-send-$err'));
    }
  }

  void _onWsInternalAddMessage(
    ChatWsInternalAddMessage e,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: [...state.messages, e.msg]));
  }

  void _onWsInternalError(ChatWsInternalError e, Emitter<ChatState> emit) {
    emit(state.copyWith(error: e.err));
  }

  @override
  Future<void> close() async {
    await _wsCmdSub?.cancel();
    await _wsUttSub?.cancel();
    return super.close();
  }
}

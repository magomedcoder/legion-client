import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/domain/entities/voice_result.dart';
import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:record/record.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final WsRemoteDataSource wsRemoteDataSource;

  VoiceRepositoryImpl(this.wsRemoteDataSource);

  final AudioRecorder _recorder = AudioRecorder();

  StreamSubscription<dynamic>? _wsSub;
  StreamSubscription<Uint8List>? _audioSub;
  bool _active = false;

  @override
  Future<void> startRecording(Function(VoiceResult result) onResult) async {
    if (!await _recorder.hasPermission()) {
      throw Exception("Нет разрешения на использование микрофона");
    }

    _active = true;

    _wsSub?.cancel();
    final wsStream = wsRemoteDataSource.connectAsrStream();
    _wsSub = wsStream.listen((event) {
      if (!_active) return;

      final map = event is String
          ? jsonDecode(event) as Map<String, dynamic>
          : Map<String, dynamic>.from(event as Map);

      final heard = (map['heard'] ?? map['asr'] ?? map['utterance']) as String?;
      final replyText = map['text'] as String?;
      final wav = map['wav_base64'] as String?;

      onResult(VoiceResult(heard: heard, text: replyText, wavBase64: wav));
    }, onError: (_) {});

    final stream = await _recorder.startStream(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 48000,
        numChannels: 1,
        bitRate: 128000,
      ),
    );

    _audioSub?.cancel();
    _audioSub = stream.listen((data) {
      if (!_active) return;
      wsRemoteDataSource.sendBytes(data);
    });
  }

  @override
  Future<void> stopRecording() async {
    _active = false;
    try {
      await _audioSub?.cancel();
      await _wsSub?.cancel();
    } finally {
      _audioSub = null;
      _wsSub = null;
      try {
        await _recorder.stop();
      } catch (_) {}
      try {
        await _recorder.dispose();
      } catch (_) {}
      await wsRemoteDataSource.disconnect();
    }
  }
}

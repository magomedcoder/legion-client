import 'dart:convert';
import 'dart:typed_data';

import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/domain/entities/voice_result.dart';
import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:record/record.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final WsRemoteDataSource remote;

  VoiceRepositoryImpl(this.remote);

  final AudioRecorder _recorder = AudioRecorder();
  Stream<Uint8List>? _streamSub;

  @override
  Future<void> startRecording(Function(VoiceResult result) onResult) async {
    if (!await _recorder.hasPermission()) {
      throw Exception("Нет разрешения на использование микрофона");
    }

    remote.connectStream().listen((event) {
      final json = jsonDecode(event);
      final result = VoiceResult(wavBase64: json['wav_base64']);
      onResult(result);
    });

    final stream = await _recorder.startStream(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 48000,
        numChannels: 1,
        bitRate: 128000,
      ),
    );

    _streamSub = stream;
    _streamSub!.listen((data) {
      remote.sendBytes(data);
    });
  }

  @override
  Future<void> stopRecording() async {
    await _recorder.stop();
    await _recorder.dispose();
    remote.disconnect();
  }
}

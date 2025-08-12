import 'dart:typed_data';

import 'package:legion/data/data_sources/voice_remote_datasource.dart';
import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:record/record.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceRemoteDataSource remote;

  VoiceRepositoryImpl(this.remote);

  final AudioRecorder _recorder = AudioRecorder();
  Stream<Uint8List>? _streamSub;

  @override
  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) {
      throw Exception("Нет разрешения на использование микрофона");
    }

    remote.connect().listen((event) {
      print("remote-connect-$event");
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
      remote.send(data);
    });
  }
}

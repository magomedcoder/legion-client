import 'dart:typed_data';

import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:record/record.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final AudioRecorder _recorder = AudioRecorder();
  Stream<Uint8List>? _streamSub;

  VoiceRepositoryImpl();

  @override
  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) {
      throw Exception("Нет разрешения на использование микрофона");
    }

    final stream = await _recorder.startStream(RecordConfig(encoder: AudioEncoder.pcm16bits));

    _streamSub = stream;
    _streamSub!.listen((data) {
      print("микрофон-stream-$data");
    });
  }
}

import 'package:legion/domain/entities/voice_result.dart';

abstract class VoiceRepository {
  Future<void> startRecording(Function(VoiceResult result) onResult);

  Future<void> stopRecording();
}

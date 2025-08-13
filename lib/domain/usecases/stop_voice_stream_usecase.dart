import 'package:legion/domain/repositories/voice_repository.dart';

class StopVoiceStreamUseCase {
  final VoiceRepository repository;

  StopVoiceStreamUseCase(this.repository);

  Future<void> call() async {
    await repository.stopRecording();
  }
}

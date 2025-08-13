import 'package:legion/domain/entities/voice_result.dart';
import 'package:legion/domain/repositories/voice_repository.dart';

class StartVoiceStreamUseCase {
  final VoiceRepository repository;

  StartVoiceStreamUseCase(this.repository);

  Future<void> call(Function(VoiceResult) onResult) async {
    await repository.startRecording(onResult);
  }
}

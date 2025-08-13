import 'package:legion/domain/repositories/voice_repository.dart';

class StopVoiceStream {
  final VoiceRepository repository;

  StopVoiceStream(this.repository);

  Future<void> call() async {
    await repository.stopRecording();
  }
}

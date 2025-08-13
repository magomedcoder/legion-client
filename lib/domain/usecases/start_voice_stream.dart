import 'package:legion/domain/entities/voice_result.dart';
import 'package:legion/domain/repositories/voice_repository.dart';

class StartVoiceStream {
  final VoiceRepository repository;

  StartVoiceStream(this.repository);

  Future<void> call(Function(VoiceResult) onResult) async {
    await repository.startRecording(onResult);
  }
}

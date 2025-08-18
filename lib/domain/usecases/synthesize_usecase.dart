import 'package:legion/domain/repositories/tts_repository.dart';

class SynthesizeUseCase {
  final TtsRepository repo;

  SynthesizeUseCase(this.repo);

  Future<String> call(String text) => repo.synthesize(text);
}

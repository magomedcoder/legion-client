import 'dart:io';

import 'package:legion/domain/entities/stt_speaker.dart';
import 'package:legion/domain/repositories/stt_repository.dart';

class UploadSttSpeakerUseCase {
  final SttRepository repository;

  UploadSttSpeakerUseCase(this.repository);

  Future<SttSpeakerEntity> call(
    File file, {
    bool diarize = true,
    bool returnSrt = false,
  }) {
    return repository.uploadAudio(file, diarize: diarize, returnSrt: returnSrt);
  }
}

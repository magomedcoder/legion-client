import 'dart:io';

import 'package:legion/domain/entities/stt_speaker.dart';

abstract class SttRepository {
  Future<SttSpeakerEntity> uploadAudio(
    File file, {
    bool diarize = true,
    bool returnSrt = false,
  });
}

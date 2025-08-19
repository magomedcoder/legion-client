import 'dart:io';

import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/domain/entities/stt_speaker.dart';
import 'package:legion/domain/repositories/stt_repository.dart';

class SttRepositoryImpl implements SttRepository {
  final RestApiRemoteDataSource restApiRemoteDataSource;

  SttRepositoryImpl(this.restApiRemoteDataSource);

  @override
  Future<SttSpeakerEntity> uploadAudio(
    File file, {
    bool diarize = true,
    bool returnSrt = false,
  }) async {
    final dto = await restApiRemoteDataSource.uploadSttSpeakerAudio(
      file,
      diarize: diarize,
      returnSrt: returnSrt,
    );
    return dto;
  }
}

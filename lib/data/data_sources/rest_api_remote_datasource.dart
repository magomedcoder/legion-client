import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:legion/core/env.dart';
import 'package:legion/data/models/command_dto.dart';
import 'package:legion/data/models/health_dto.dart';
import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/data/models/stt_speaker_dto.dart';
import 'package:legion/data/models/synthesize_dto.dart';
import 'package:legion/data/models/utterance_dto.dart';

abstract class IRestApiRemoteDataSource {
  Future<ReplyDto> postCommands(CommandRequestDto dto);

  Future<HealthDto> getHealth();

  Future<SynthesizeReplyDto> synthesize(SynthesizeRequestDto dto);

  Future<ReplyDto> postUtterance(UtteranceRequestDto dto);

  Future<SttSpeakerDto> uploadSttSpeakerAudio(
    File file, {
    bool diarize = true,
    bool returnSrt = false,
  });
}

class RestApiRemoteDataSource implements IRestApiRemoteDataSource {
  final Dio _dio;

  RestApiRemoteDataSource(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: "${Env.http}/api/v1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );
  }

  @override
  Future<ReplyDto> postCommands(CommandRequestDto dto) async {
    final res = await _dio.post('/commands', data: dto.toJson());
    return ReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<HealthDto> getHealth() async {
    final res = await _dio.get('/health');
    return HealthDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<SynthesizeReplyDto> synthesize(SynthesizeRequestDto dto) async {
    final res = await _dio.post('/synthesize', data: dto.toJson());
    return SynthesizeReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<ReplyDto> postUtterance(UtteranceRequestDto dto) async {
    final res = await _dio.post('/utterances', data: dto.toJson());
    return ReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<SttSpeakerDto> uploadSttSpeakerAudio(
    File file, {
    bool diarize = true,
    bool returnSrt = false,
  }) async {
    final form = FormData.fromMap({
      'diarize': diarize.toString(),
      'return_srt': returnSrt.toString(),
      'file': await MultipartFile.fromFile(file.path),
    });

    try {
      final res = await _dio.post(
        '/stt-speaker/upload',
        data: form,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          receiveTimeout: Duration.zero,
          sendTimeout: Duration.zero,
        ),
      );

      final data = res.data is String
          ? Map<String, dynamic>.from(jsonDecode(res.data as String))
          : Map<String, dynamic>.from(res.data as Map);

      final result = Map<String, dynamic>.from(
        (data['result'] as Map?) ?? data,
      );
      return SttSpeakerDto.fromJson(result);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final body = e.response?.data;
      throw Exception(
        'Не удалась: $code ${body is String ? body : jsonEncode(body)}',
      );
    }
  }
}

import 'package:dio/dio.dart';
import 'package:legion/core/env.dart';
import 'package:legion/data/models/command_dto.dart';
import 'package:legion/data/models/health_dto.dart';
import 'package:legion/data/models/reply_dto.dart';
import 'package:legion/data/models/synthesize_dto.dart';
import 'package:legion/data/models/utterance_dto.dart';

abstract class IRestApiRemoteDataSource {
  Future<ReplyDto> postCommands(CommandRequestDto dto);

  Future<HealthDto> getHealth();

  Future<SynthesizeReplyDto> synthesize(SynthesizeRequestDto dto);

  Future<ReplyDto> postUtterance(UtteranceRequestDto dto);
}

class RestApiRemoteDataSource implements IRestApiRemoteDataSource {
  final Dio _dio;

  RestApiRemoteDataSource(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: Env.http,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );
  }

  @override
  Future<ReplyDto> postCommands(CommandRequestDto dto) async {
    final res = await _dio.post('/api/v1/commands', data: dto.toJson());
    return ReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<HealthDto> getHealth() async {
    final res = await _dio.get('/api/v1/health');
    return HealthDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<SynthesizeReplyDto> synthesize(SynthesizeRequestDto dto) async {
    final res = await _dio.post('/api/v1/synthesize', data: dto.toJson());
    return SynthesizeReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<ReplyDto> postUtterance(UtteranceRequestDto dto) async {
    final res = await _dio.post('/api/v1/utterances', data: dto.toJson());
    return ReplyDto.fromJson(Map<String, dynamic>.from(res.data));
  }
}

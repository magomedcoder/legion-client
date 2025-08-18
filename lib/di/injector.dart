// lib/di/injector.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/data/repositories/chat_repository_impl.dart';
import 'package:legion/data/repositories/health_repository_impl.dart';
import 'package:legion/data/repositories/nlu_repository_impl.dart';
import 'package:legion/data/repositories/tts_repository_impl.dart';
import 'package:legion/data/repositories/voice_repository_impl.dart';
import 'package:legion/data/repositories/ws_command_repository_impl.dart';
import 'package:legion/data/repositories/ws_utterance_repository_impl.dart';
import 'package:legion/domain/repositories/chat_repository.dart';
import 'package:legion/domain/repositories/health_repository.dart';
import 'package:legion/domain/repositories/nlu_repository.dart';
import 'package:legion/domain/repositories/tts_repository.dart';
import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:legion/domain/repositories/ws_command_repository.dart';
import 'package:legion/domain/repositories/ws_utterance_repository.dart';
import 'package:legion/domain/usecases/check_health_usecase.dart';
import 'package:legion/domain/usecases/send_command_usecase.dart';
import 'package:legion/domain/usecases/send_utterance_usecase.dart';
import 'package:legion/domain/usecases/start_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/stop_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/synthesize_usecase.dart';
import 'package:legion/domain/usecases/ws_commands_usecases.dart';
import 'package:legion/domain/usecases/ws_utterances_usecases.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton(() => RestApiRemoteDataSource(sl()));
  sl.registerLazySingleton(() => WsRemoteDataSource());

  sl.registerLazySingleton<VoiceRepository>(() => VoiceRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<HealthRepository>(() => HealthRepositoryImpl(sl()));
  sl.registerLazySingleton<TtsRepository>(() => TtsRepositoryImpl(sl()));
  sl.registerLazySingleton<NluRepository>(() => NluRepositoryImpl(sl()));
  sl.registerLazySingleton<WsCommandRepository>(
    () => WsCommandRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WsUtteranceRepository>(
    () => WsUtteranceRepositoryImpl(sl()),
  );

  sl.registerFactory(() => StartVoiceStreamUseCase(sl()));
  sl.registerFactory(() => StopVoiceStreamUseCase(sl()));
  sl.registerFactory(() => SendCommandUseCase(sl()));
  sl.registerFactory(() => CheckHealthUseCase(sl()));
  sl.registerFactory(() => SynthesizeUseCase(sl()));
  sl.registerFactory(() => SendUtteranceUseCase(sl()));
  sl.registerFactory(() => ConnectWsCommandsUseCase(sl()));
  sl.registerFactory(() => SendWsCommandUseCase(sl()));
  sl.registerFactory(() => DisconnectWsCommandsUseCase(sl()));
  sl.registerFactory(() => ConnectWsUtterancesUseCase(sl()));
  sl.registerFactory(() => SendWsUtteranceUseCase(sl()));
  sl.registerFactory(() => DisconnectWsUtterancesUseCase(sl()));

  sl.registerFactory(
    () => ChatBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}

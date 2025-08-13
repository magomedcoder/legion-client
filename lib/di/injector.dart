import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:legion/data/data_sources/rest_api_remote_datasource.dart';
import 'package:legion/data/data_sources/ws_remote_datasource.dart';
import 'package:legion/data/repositories/chat_repository_impl.dart';
import 'package:legion/data/repositories/voice_repository_impl.dart';
import 'package:legion/domain/repositories/chat_repository.dart';
import 'package:legion/domain/repositories/voice_repository.dart';
import 'package:legion/domain/usecases/send_command_usecase.dart';
import 'package:legion/domain/usecases/start_voice_stream_usecase.dart';
import 'package:legion/domain/usecases/stop_voice_stream_usecase.dart';
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

  sl.registerFactory(() => StartVoiceStreamUseCase(sl()));
  sl.registerFactory(() => StopVoiceStreamUseCase(sl()));
  sl.registerFactory(() => SendCommandUseCase(sl()));

  sl.registerFactory(() => ChatBloc(sl(), sl(), sl()));
}

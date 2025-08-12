import 'package:flutter/material.dart';
import 'package:legion/data/data_sources/voice_remote_datasource.dart';
import 'package:legion/data/repositories/voice_repository_impl.dart';
import 'package:legion/domain/usecases/start_voice_stream.dart';
import 'package:legion/presentation/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = WebSocketVoiceRemoteDataSource();
    final repository = VoiceRepositoryImpl(dataSource);
    final startUseCase = StartVoiceStream(repository);
    return MaterialApp(
      title: 'Легион',
      home: HomeScreen(startVoice: startUseCase),
    );
  }
}

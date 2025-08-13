import 'package:flutter/material.dart';
import 'package:legion/domain/usecases/start_voice_stream.dart';
import 'package:legion/domain/usecases/stop_voice_stream.dart';
import 'package:legion/presentation/widgets/audio_player_widget.dart';

class HomeScreen extends StatefulWidget {
  final StartVoiceStream startVoice;
  final StopVoiceStream stopVoice;

  const HomeScreen({
    super.key,
    required this.startVoice,
    required this.stopVoice,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRecording = false;
  String? wavBase64;

  void _toggleRecording() async {
    if (isRecording) {
      await widget.stopVoice();
    } else {
      await widget.startVoice((result) {
        setState(() {
          wavBase64 = result.wavBase64;
        });
      });
    }

    setState(() => isRecording = !isRecording);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Легион')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _toggleRecording,
            child: Text(isRecording ? "Остановить" : "Говорить"),
          ),
          if (wavBase64 != null) AudioPlayerWidget(base64Str: wavBase64!),
        ],
      ),
    );
  }
}

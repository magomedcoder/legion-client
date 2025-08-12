import 'package:flutter/material.dart';
import 'package:legion/domain/usecases/start_voice_stream.dart';

class HomeScreen extends StatefulWidget {
  final StartVoiceStream startVoice;

  const HomeScreen({super.key, required this.startVoice});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _toggleRecording() async {
    await widget.startVoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Легион')),
      body: Column(
        children: [
          ElevatedButton(onPressed: _toggleRecording, child: Text("Микрофон")),
        ],
      ),
    );
  }
}

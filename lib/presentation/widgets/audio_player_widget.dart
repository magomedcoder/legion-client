import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String base64Str;

  const AudioPlayerWidget({super.key, required this.base64Str});

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(base64Str);
    final player = AudioPlayer();

    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => player.play(BytesSource(Uint8List.fromList(bytes))),
          child: const Text("Воспроизвести ответ"),
        ),
      ],
    );
  }
}

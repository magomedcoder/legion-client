import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String base64Str;

  const AudioPlayerWidget({super.key, required this.base64Str});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAudioFromBase64(widget.base64Str);
  }

  Future<void> _playAudioFromBase64(String base64Str) async {
    try {
      final Uint8List bytes = base64Decode(base64Str);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/legion.wav');
      await file.writeAsBytes(bytes);
      await _player.play(DeviceFileSource(file.path));
    } catch (e) {
      print("_playAudioFromBase64-$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

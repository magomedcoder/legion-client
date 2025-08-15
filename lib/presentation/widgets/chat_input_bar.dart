import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_event.dart';
import 'package:legion/presentation/bloc/chat_state.dart';
import 'package:legion/presentation/widgets/audio_player_widget.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;

  const ChatInputBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Напишите команду…',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        context.read<ChatBloc>().add(MicVoice());
                      },
                      icon: state.isRecording
                          ? const Icon(Icons.mic_off)
                          : const Icon(Icons.mic),
                    ),
                    if (state.wavBase64 != null)
                      AudioPlayerWidget(base64Str: state.wavBase64!),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        context.read<ChatBloc>().add(ChatSendTextPressed(text));
                        controller.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

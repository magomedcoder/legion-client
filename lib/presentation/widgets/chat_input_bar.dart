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
            Expanded(child: TextField(controller: controller)),
            const SizedBox(width: 8),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final text = controller.text.trim();
                        context.read<ChatBloc>().add(ChatSendTextPressed(text));
                        controller.clear();
                      },
                      child: Text("Отправить"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(MicVoice());
                      },
                      child: Text(
                        state.isRecording ? "Остановить" : "Микрофон",
                      ),
                    ),
                    if (state.wavBase64 != null)
                      AudioPlayerWidget(base64Str: state.wavBase64!),
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

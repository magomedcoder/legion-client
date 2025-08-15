import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_event.dart';
import 'package:legion/presentation/bloc/chat_state.dart';
import 'package:legion/presentation/widgets/audio_player_widget.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;

  const ChatInputBar({super.key, required this.controller});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _refocus() => Future.microtask(() => _focusNode.requestFocus());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (p, n) =>
              p.isRecording != n.isRecording || p.wavBase64 != n.wavBase64,
          builder: (context, state) {
            final isRec = state.isRecording;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (isRec) {
                _focusNode.unfocus();
              } else {
                _refocus();
              }
            });

            return Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: isRec,
                    child: AnimatedOpacity(
                      opacity: isRec ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: TextField(
                        focusNode: _focusNode,
                        controller: widget.controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Напишите команду…',
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (text) {
                          if (isRec) return;
                          final t = text.trim();
                          if (t.isEmpty) return;
                          context.read<ChatBloc>().add(ChatSendTextPressed(t));
                          widget.controller.clear();
                          _refocus();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                IconButton.filled(
                  onPressed: () {
                    context.read<ChatBloc>().add(MicVoice());
                  },
                  icon: isRec
                      ? const Icon(Icons.mic_off)
                      : const Icon(Icons.mic),
                ),

                if (state.wavBase64 != null) ...[
                  const SizedBox(width: 8),
                  AudioPlayerWidget(base64Str: state.wavBase64!),
                ],

                const SizedBox(width: 8),

                IconButton.filled(
                  onPressed: isRec
                      ? null
                      : () {
                          final text = widget.controller.text.trim();
                          if (text.isEmpty) return;
                          context.read<ChatBloc>().add(
                            ChatSendTextPressed(text),
                          );
                          widget.controller.clear();
                          _refocus();
                        },
                  icon: const Icon(Icons.send),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

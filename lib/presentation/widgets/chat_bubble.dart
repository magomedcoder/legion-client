import 'package:flutter/material.dart';
import 'package:legion/domain/entities/message.dart';
import 'package:legion/presentation/widgets/audio_player_widget.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool muted;

  const ChatBubble({super.key, required this.message, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final cs = base.colorScheme.copyWith(
      primaryContainer: const Color(0xFF202124),
      onPrimaryContainer: Colors.white,
      secondaryContainer: const Color(0xFF1A1A1A),
      onSecondaryContainer: Colors.white,
    );
    final isUser = message.author == MessageAuthor.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: isUser ? cs.primaryContainer : cs.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.text != null)
              Text(
                message.text!,
                style: TextStyle(
                  color: isUser
                      ? cs.onPrimaryContainer
                      : cs.onSecondaryContainer,
                ),
              ),
            if (message.wavBase64 != null && !muted)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AudioPlayerWidget(base64Str: message.wavBase64!),
              ),
          ],
        ),
      ),
    );
  }
}

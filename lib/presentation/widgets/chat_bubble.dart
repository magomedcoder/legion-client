import 'package:flutter/material.dart';
import 'package:legion/domain/entities/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          children: [if (message.text != null) Text(message.text!)],
        ),
      ),
    );
  }
}

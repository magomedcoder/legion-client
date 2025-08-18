import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_state.dart';
import 'package:legion/presentation/widgets/chat_bubble.dart';
import 'package:legion/presentation/widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  bool _muted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Легион - Чат'),
        actions: [
          IconButton(
            tooltip: _muted ? 'Включить звук' : 'Выключить звук',
            onPressed: () {
              setState(() {
                _muted = !_muted;
              });
            },
            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return ListView.builder(
                    reverse: false,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) =>
                        ChatBubble(message: state.messages[i], muted: _muted),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ChatInputBar(controller: _controller),
          ],
        ),
      ),
    );
  }
}

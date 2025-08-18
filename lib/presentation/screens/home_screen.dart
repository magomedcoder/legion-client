import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_state.dart';
import 'package:legion/presentation/screens/dev_tools_screen.dart';
import 'package:legion/presentation/widgets/chat_bubble.dart';
import 'package:legion/presentation/widgets/chat_input_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Легион'),
        actions: [
          IconButton(
            tooltip: 'Панель разработчика',
            onPressed: () {
              final chatBloc = context.read<ChatBloc>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: chatBloc,
                    child: const DevToolsScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.developer_mode),
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
                        ChatBubble(message: state.messages[i]),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_state.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Легион')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MenuCard(
                icon: Icons.chat_bubble_outline,
                title: 'Чат',
                subtitle: 'Отправка сообщений и ответы',
                onTap: () => Navigator.of(context).pushNamed('/chat'),
              ),
              _MenuCard(
                icon: Icons.graphic_eq,
                title: 'STT спикеры',
                subtitle: 'Загрузить аудио и распознать',
                onTap: () => Navigator.of(context).pushNamed('/stt-speaker'),
              ),
              _MenuCard(
                icon: Icons.developer_mode,
                title: 'Панель разработчика',
                subtitle: 'HTTP и WebSocket проверки',
                onTap: () => Navigator.of(context).pushNamed('/devtools'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool ok;

  const _StatusChip({required this.label, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.circle,
        size: 12,
        color: ok ? Colors.green : Colors.grey,
      ),
      label: Text(label),
    );
  }
}

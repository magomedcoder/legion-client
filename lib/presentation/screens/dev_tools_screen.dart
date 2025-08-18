import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/chat_event.dart';
import 'package:legion/presentation/bloc/chat_state.dart';

class DevToolsScreen extends StatefulWidget {
  const DevToolsScreen({super.key});

  @override
  State<DevToolsScreen> createState() => _DevToolsScreenState();
}

class _DevToolsScreenState extends State<DevToolsScreen> {
  final _httpTextCtrl = TextEditingController(text: 'Привет, озвучь меня');
  final _wsCmdTextCtrl = TextEditingController(text: 'таймер 5 минут');
  final _wsUttTextCtrl = TextEditingController(
    text: 'легион поставь таймер 5 минут',
  );
  final _wsCmdFormatCtrl = TextEditingController(text: 'saytxt,saywav');
  final _wsUttFormatCtrl = TextEditingController(text: 'saytxt');

  @override
  void dispose() {
    _httpTextCtrl.dispose();
    _wsCmdTextCtrl.dispose();
    _wsUttTextCtrl.dispose();
    _wsCmdFormatCtrl.dispose();
    _wsUttFormatCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Панель разработчика')),
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (p, n) =>
            p.healthy != n.healthy ||
            p.wsConnected != n.wsConnected ||
            p.error != n.error,
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  _StatusChip(
                    label: 'health',
                    ok: state.healthy,
                    tooltip: state.healthy ? 'OK' : 'Неизвестно',
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'ws(/commands)',
                    ok: state.wsConnected,
                    tooltip: state.wsConnected ? 'Подключить' : 'Отключить',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _Section(
                title: 'HTTP: /api/v1/health',
                child: FilledButton(
                  onPressed: () {
                    bloc.add(ChatHealthCheckRequested());
                    _snack('Запрос /health отправлен');
                  },
                  child: const Text('Проверить'),
                ),
              ),

              _Section(
                title: 'HTTP: /api/v1/synthesize',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _httpTextCtrl,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Текст для озвучивания',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        final t = _httpTextCtrl.text.trim();
                        if (t.isEmpty) return;
                        bloc.add(ChatSynthesizeRequested(t));
                        _snack('Синтез отправлен');
                      },
                      child: const Text('Озвучить'),
                    ),
                  ],
                ),
              ),

              _Section(
                title: 'HTTP: /api/v1/utterances',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _wsUttTextCtrl,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Сырая фраза',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _wsUttFormatCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Формат (none|saytxt|saywav|saytxt,saywav)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        final t = _wsUttTextCtrl.text.trim();
                        final f = _wsUttFormatCtrl.text.trim().isEmpty
                            ? 'saytxt'
                            : _wsUttFormatCtrl.text.trim();
                        if (t.isEmpty) return;
                        bloc.add(ChatUtteranceSendPressed(t, f));
                        _snack('HTTP utterance отправлена (формат: $f)');
                      },
                      child: const Text('Отправить (HTTP)'),
                    ),
                  ],
                ),
              ),

              _Section(
                title: 'WebSocket: /ws/commands',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () => bloc.add(ChatWsCommandsConnect()),
                          child: const Text('Подключить'),
                        ),
                        OutlinedButton(
                          onPressed: () => bloc.add(ChatWsCommandsDisconnect()),
                          child: const Text('Отключить'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _wsCmdTextCtrl,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Команда',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _wsCmdFormatCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Формат (none|saytxt|saywav|saytxt,saywav)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        final t = _wsCmdTextCtrl.text.trim();
                        final f = _wsCmdFormatCtrl.text.trim().isEmpty
                            ? 'saytxt,saywav'
                            : _wsCmdFormatCtrl.text.trim();
                        if (t.isEmpty) return;
                        bloc.add(ChatWsCommandsSend(t, f));
                        _snack('WS /commands: отправлено');
                      },
                      child: const Text('Отправить (WS)'),
                    ),
                  ],
                ),
              ),

              _Section(
                title: 'WebSocket: /ws/utterances',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () => bloc.add(ChatWsUtterancesConnect()),
                          child: const Text('Подключить'),
                        ),
                        OutlinedButton(
                          onPressed: () =>
                              bloc.add(ChatWsUtterancesDisconnect()),
                          child: const Text('Отключить'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _wsUttTextCtrl,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Сырая фраза',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _wsUttFormatCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Формат (none|saytxt|saywav|saytxt,saywav)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        final t = _wsUttTextCtrl.text.trim();
                        final f = _wsUttFormatCtrl.text.trim().isEmpty
                            ? 'saytxt'
                            : _wsUttFormatCtrl.text.trim();
                        if (t.isEmpty) return;
                        context.read<ChatBloc>().add(
                          ChatWsUtterancesSend(t, f),
                        );
                        _snack('WS /utterances: отправлено');
                      },
                      child: const Text('Отправить (WS)'),
                    ),
                  ],
                ),
              ),

              if (state.error != null && state.error!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Ошибка: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool ok;
  final String? tooltip;

  const _StatusChip({required this.label, required this.ok, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final chip = Chip(
      avatar: Icon(
        Icons.circle,
        size: 12,
        color: ok ? Colors.green : Colors.grey,
      ),
      label: Text(label),
    );
    return Tooltip(message: tooltip ?? label, child: chip);
  }
}

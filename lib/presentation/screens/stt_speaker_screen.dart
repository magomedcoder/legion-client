import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/presentation/bloc/stt_cubit.dart';
import 'package:legion/presentation/bloc/stt_state.dart';

class SttSpeakerScreen extends StatelessWidget {
  const SttSpeakerScreen({super.key});

  Future<void> _pickAndUpload(BuildContext context) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: false,
    );
    final path = res?.files.single.path;
    if (path == null) return;
    await context.read<SttCubit>().uploadAndParse(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Легион - STT Спикеры'),
        actions: [
          IconButton(
            onPressed: () => _pickAndUpload(context),
            icon: const Icon(Icons.upload_file),
            tooltip: 'Загрузить аудио',
          ),
        ],
      ),
      body: BlocBuilder<SttCubit, SttState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }

          if (state.data == null) {
            return Center(
              child: TextButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Выбрать аудио и распознать'),
                onPressed: () => _pickAndUpload(context),
              ),
            );
          }

          final data = state.data!;
          final blocks = data.blocks;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   color: Theme.of(context).colorScheme.surfaceContainerHighest,
              //   child: Text(
              //     data.text.isEmpty
              //         ? 'Текст не распознан'
              //         : '',
              //         //: data.text,
              //     style: const TextStyle(fontSize: 14),
              //   ),
              // ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: blocks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final b = blocks[i];
                    return ListTile(
                      dense: false,
                      title: Text('Пользователь ${b.spk}'),
                      subtitle: Text(b.text),
                      trailing: Text(
                        '${b.start.toStringAsFixed(1)}–${b.end.toStringAsFixed(1)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/core/theme.dart';
import 'package:legion/di/injector.dart' as di;
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/bloc/stt_cubit.dart';
import 'package:legion/presentation/screens/dev_tools_screen.dart';
import 'package:legion/presentation/screens/chat_screen.dart';
import 'package:legion/presentation/screens/menu_screen.dart';
import 'package:legion/presentation/screens/stt_speaker_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ChatBloc>()),
        BlocProvider(create: (_) => di.sl<SttCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Легион',
        theme: theme,
        home: const MenuScreen(),
        routes: {
          '/chat': (_) => const ChatScreen(),
          '/stt-speaker': (_) => const SttSpeakerScreen(),
          '/devtools': (_) => const DevToolsScreen(),
        },
      ),
    );
  }
}

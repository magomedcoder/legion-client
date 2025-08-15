import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/core/theme.dart';
import 'package:legion/di/injector.dart' as di;
import 'package:legion/presentation/bloc/chat_bloc.dart';
import 'package:legion/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Легион',
      theme: theme,
      home: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => di.sl<ChatBloc>())],
        child: const HomeScreen(),
      ),
    );
  }
}

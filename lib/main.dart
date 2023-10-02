import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/TmdbObserver.dart';
import 'package:tmdb_flutter/presentation/on_boarding_screen.dart';
import 'package:tmdb_flutter/presentation/settings_screen/SettingsScreenCubit.dart';

import 'firebase_options.dart';

Future<void> main() async {
  Bloc.observer = TmdbObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BlocProvider(
      create: (_) => SettingsScreenCubit(const SettingsScreenState()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsScreenCubit, SettingsScreenState>(
      builder: (BuildContext context, SettingsScreenState state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            useMaterial3: true,
          ),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: OnBoardingScreen(),
      ),
    );
  }
}

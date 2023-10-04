import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/data/shared_prefs_helper.dart';
import 'package:tmdb_flutter/presentation/content_screen.dart';
import 'package:tmdb_flutter/presentation/on_boarding_screen.dart';
import 'package:tmdb_flutter/theme_cubit.dart';
import 'package:tmdb_flutter/tmdb_observer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  Bloc.observer = TmdbObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final loginStatus =
      await SharedPreferencesHelper.instance.getBool("isUserLoggedIn");
  final isDarkTheme =
      await SharedPreferencesHelper.instance.getBool("isDarkTheme");
  runApp(BlocProvider(
      create: (_) => ThemeCubit(isDarkTheme),
      child: MyApp(isUserLoggedIn: loginStatus)));
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyApp({
    super.key,
    required this.isUserLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    // read ThemeCubit
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            useMaterial3: true,
          ),
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: MyHomePage(isUserLoggedIn: isUserLoggedIn),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyHomePage({super.key, required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isUserLoggedIn ? const ContentScreen() : const OnBoardingScreen(),
    );
  }
}

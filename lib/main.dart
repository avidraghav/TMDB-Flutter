import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_flutter/data/shared_prefs_helper.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen_cubit.dart';
import 'package:tmdb_flutter/presentation/content_screen.dart';
import 'package:tmdb_flutter/presentation/on_boarding_screen.dart';
import 'package:tmdb_flutter/theme_cubit.dart';
import 'package:tmdb_flutter/tmdb_observer.dart';

import 'firebase_options.dart';

Future<void> main() async {
  Bloc.observer = TmdbObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final isDarkTheme =
      await SharedPreferencesHelper.instance.getBool("isDarkTheme");
  runApp(MyApp(isDarkTheme: isDarkTheme));
}

final GoRouter _router = GoRouter(
  initialLocation: '/home_page',
  routes: <RouteBase>[
    GoRoute(
      path: '/home_page',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'content_screen',
          builder: (BuildContext context, GoRouterState state) {
            return const ContentScreen();
          },
        ),
        GoRoute(
          path: 'on_boarding_screen',
          builder: (BuildContext context, GoRouterState state) {
            return const OnBoardingScreen();
          },
        ),
        GoRoute(
          path: 'auth_screen',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
                create: (_) => AuthScreenCubit(const AuthScreenState()),
                child: const AuthScreen());
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({
    super.key,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(isDarkTheme),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkTheme) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
            // themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferencesHelper.instance
          .getBool("isUserLoggedIn")
          .then((loginStatus) {
        print("isUserLoggedIn logged in?: $loginStatus");
        if (loginStatus) {
          context.pushReplacement('/home_page/content_screen');
        } else {
          context.pushReplacement('/home_page/on_boarding_screen');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Placeholder
    );
  }
}

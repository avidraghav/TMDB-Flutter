import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/domain/model/movie.dart';
import 'package:tmdb_flutter/presentation/details_screen/DetailsScreenCubit.dart';
import 'package:tmdb_flutter/presentation/details_screen/details_screen.dart';
import 'package:tmdb_flutter/presentation/movies_screen/movies_screen_cubit.dart';
import 'package:tmdb_flutter/presentation/movies_screen/movies_screen_vm.dart';
import 'package:tmdb_flutter/presentation/settings_screen/settings_screen.dart';

import '../../auth_state_cubit.dart';
import '../../data/shared_prefs_helper.dart';
import '../../theme_cubit.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late bool isUserLoggedIn;
  late bool isDarkTheme;
  late MoviesScreenVM _viewModel;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.5);

  @override
  void initState() {
    _viewModel = MoviesScreenVM();
    _viewModel.checkInternetConnectivity().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _viewModel.fetchDataFromNetwork().then((data) {
          _viewModel.storeDataInDatabase(data.movies ?? []).then((value) {
            _viewModel.getCachedMoviesFromDatabase().then((movies) {
              context.read<MoviesScreenCubit>().setMovies(movies);
              context.read<MoviesScreenCubit>().setLoadingState(false);
            });
          });
        }).catchError((e) {
          context.read<MoviesScreenCubit>().setLoadingState(false);
          context.read<MoviesScreenCubit>().setErrorMessage(e.toString());
        });
      } else {
        _viewModel.getCachedMoviesFromDatabase().then((movies) {
          context.read<MoviesScreenCubit>().setLoadingState(false);
          if (movies.isNotEmpty) {
            context.read<MoviesScreenCubit>().setMovies(movies);
          } else {
            context
                .read<MoviesScreenCubit>()
                .setErrorMessage('Please enable your internet connection.');
          }
        }).catchError((e) {});
      }
    });

    pageController.addListener(() {
      context.read<MoviesScreenCubit>().setCurrentPage(pageController.page ?? 0);
    });

    SharedPreferencesHelper.instance.getBool("isUserLoggedIn").then((value) {
      isUserLoggedIn = value;
    });
    SharedPreferencesHelper.instance.getBool("isDarkTheme").then((value) {
      isDarkTheme = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesScreenCubit, MoviesScreenState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Trending Movies")),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                        BlocProvider(
                          create: (BuildContext context) =>
                              AuthStateCubit(isUserLoggedIn),
                        ),
                        BlocProvider(
                          create: (BuildContext context) =>
                              ThemeCubit(isDarkTheme),
                        ),
                      ], child: const SettingsScreen()),
                    ));
              },
            )
          ],
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
                ? Center(child: Text(state.errorMessage!))
                : state.movies.isEmpty
                    ? const Center(child: Text('No data to show right now'))
                    : Padding(
                        padding: const EdgeInsets.only(top: 80.0, bottom: 80.0),
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movies.length,
                            controller: pageController,
                            itemBuilder: (BuildContext context, int index) {
                              double scale = 1;
                              double offset = state.currentPage - index;
                              scale =
                                  (1 - (offset.abs() * .25)).clamp(0.8, 1.0);
                              return Transform.scale(
                                scale: scale,
                                child: Center(
                                  child: MovieItem(movie: state.movies[index]),
                                ),
                              );
                            })),
      );
    });
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (_) =>
                      DetailsScreenCubit(DetailsScreenState(movie: movie)),
                  child: DetailsScreen(movie: movie)),
            ));
      },
      child: Card(
        child: Center(child: Text(movie.title.toString())),
      ),
    );
  }
}

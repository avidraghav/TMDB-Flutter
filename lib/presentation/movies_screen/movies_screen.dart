import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmdb_flutter/data/database_helper.dart';
import 'package:tmdb_flutter/domain/model/movie.dart';
import 'package:tmdb_flutter/domain/model/popular_movie_response.dart';
import 'package:tmdb_flutter/domain/repository/movies_screen_repo.dart';
import 'package:tmdb_flutter/presentation/details_screen/DetailsScreenCubit.dart';
import 'package:tmdb_flutter/presentation/details_screen/details_screen.dart';
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
  List<Movie> movies = [];
  bool isLoading = true;
  String errorMessage = "";
  late bool isUserLoggedIn;
  late bool isDarkTheme;

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.5);
  double currentPage = 0;

  Dio configureDio() {
    final options = BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    return Dio(options);
  }

  @override
  void initState() {
    DatabaseHelper().db.then((db) {
      getMovies(db);
    });

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page ?? 0;
      });
    });

    SharedPreferencesHelper.instance.getBool("isUserLoggedIn").then((value) {
      isUserLoggedIn = value;
    });
    SharedPreferencesHelper.instance.getBool("isDarkTheme").then((value) {
      isDarkTheme = value;
    });
    super.initState();
  }

  Future<void> getMovies(Database db) async {
    try {
      final hasInternet = await checkInternetConnectivity();

      if (hasInternet) {
        final data = await fetchDataFromNetwork();

        await storeDataInDatabase(db, data.movies!);

        List<Movie> cachedMovies = await getCachedMoviesFromDatabase(db);

        setState(() {
          movies = cachedMovies;
          isLoading = false;
        });
      } else {
        final cachedMovies = await getCachedMoviesFromDatabase(db);

        if (cachedMovies.isNotEmpty) {
          setState(() {
            movies = cachedMovies;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Please enable your internet connection.';
            movies = [];
          });
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $error';
      });
    }
  }

  Future<PopularMovieResponse> fetchDataFromNetwork() async {
    final dio = configureDio();
    MoviesScreenRepo repo = MoviesScreenRepo(dio: dio);
    Future<PopularMovieResponse> moviesResponse = repo.getTrending(dio);
    return moviesResponse;
  }

  Future<void> storeDataInDatabase(Database db, List<Movie> movies) async {
    try {
      for (final movie in movies) {
        await db.insert('movies', movie.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (error) {
      throw 'Error storing data in the database: $error';
    }
  }

  Future<List<Movie>> getCachedMoviesFromDatabase(Database db) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('movies');
      return List.generate(maps.length, (i) {
        return Movie.fromJson(maps[i]);
      });
    } catch (error) {
      throw 'Error retrieving data from the database: $error';
    }
  }

  Future<bool> checkInternetConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : movies.isEmpty
                  ? const Center(child: Text('No data to show right now'))
                  : Padding(
                      padding: const EdgeInsets.only(top: 80.0, bottom: 80.0),
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          controller: pageController,
                          itemBuilder: (BuildContext context, int index) {
                            double scale = 1;
                            double offset = currentPage - index;
                            scale = (1 - (offset.abs() * .25)).clamp(0.8, 1.0);
                            return Transform.scale(
                              scale: scale,
                              child: Center(
                                child: MovieItem(movie: movies[index]),
                              ),
                            );
                          })),
    );
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

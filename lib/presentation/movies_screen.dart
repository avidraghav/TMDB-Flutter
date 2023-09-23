import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmdb_flutter/domain/model/movie.dart';
import 'package:tmdb_flutter/domain/model/popular_movie_response.dart';
import 'package:tmdb_flutter/domain/repository/movies_screen_repo.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  //final MoviesScreenRepo repo;

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Database _database;
  List<Movie> movies = [];
  bool isLoading = true;
  String errorMessage = "";

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
    initializeDatabase();

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page ?? 0;
      });
    });
    super.initState();
  }

  Future<void> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tmdb_flutter.db');

    try {
      // Open the database (or create if it doesn't exist)
      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // Create the table to store data
        await db.execute(
          'CREATE TABLE movies('
          'id INTEGER PRIMARY KEY, '
          'adult INTEGER, '
          'backdrop_path TEXT, '
          'genre_ids TEXT, '
          'original_language TEXT, '
          'original_title TEXT, '
          'overview TEXT, '
          'popularity REAL, '
          'poster_path TEXT, '
          'release_date TEXT, '
          'title TEXT, '
          'video INTEGER, '
          'vote_average REAL, '
          'vote_count INTEGER'
          ')',
        );
      });

      // Check for internet connectivity
      final hasInternet = await checkInternetConnectivity();

      if (hasInternet) {
        final data = await fetchDataFromNetwork();

        await storeDataInDatabase(data.movies!);

        List<Movie> cachedMovies = await getCachedMoviesFromDatabase();

        setState(() {
          movies = cachedMovies;
          isLoading = false;
        });
      } else {
        final cachedMovies = await getCachedMoviesFromDatabase();

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

  Future<void> storeDataInDatabase(List<Movie> movies) async {
    try {
      for (final movie in movies) {
        await _database.insert('movies', movie.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (error) {
      throw 'Error storing data in the database: $error';
    }
  }

  Future<List<Movie>> getCachedMoviesFromDatabase() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('movies');
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
      appBar: AppBar(title: const Center(child: Text("Trending Movies"))),
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
    return Card(
      child: Center(child: Text(movie.title.toString())),
    );
  }
}

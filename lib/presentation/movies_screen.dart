import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_flutter/domain/model/popular_movie_response.dart';
import 'package:tmdb_flutter/domain/repository/movies_screen_repo.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  //final MoviesScreenRepo repo;

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Future<PopularMovieResponse> moviesResponse;

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
    var dio = configureDio();
    MoviesScreenRepo repo = MoviesScreenRepo(dio: dio);
    moviesResponse = repo.getTrending(dio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<PopularMovieResponse>(
        future: moviesResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.movies![1].title!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}

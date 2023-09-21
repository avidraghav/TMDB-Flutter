import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  late Future<PopularMovieResponse> moviesResponse;
  final PageController _pageController = PageController(initialPage: 0);

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
        child: Column(
          children: [
            const SafeArea(child: Text("Trending Movies")),
            Flexible(
              child: FutureBuilder<PopularMovieResponse>(
                future: moviesResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.movies!.length,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: const EdgeInsets.all(80.0),
                            child: MovieItem(movie: snapshot.data!.movies![index]),
                          ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Card(
        child: Center(child: Text(movie.title.toString())),
      ),
    );
  }
}

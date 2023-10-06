import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/dio_service.dart';
import '../../dependencies_config.dart';
import '../../domain/database_helper.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/popular_movie_response.dart';
import '../../domain/repository/movies_screen_repo.dart';

class MoviesScreenVM {

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


  Future<PopularMovieResponse> fetchDataFromNetwork() async {
    final dio = getIt<DioService>().dio;
    MoviesScreenRepo repo = MoviesScreenRepo(dio: dio);
    Future<PopularMovieResponse> moviesResponse = repo.getTrending(dio);
    return moviesResponse;
  }

  Future<void> storeDataInDatabase(List<Movie> movies) async {
 //   try {
      final db = await getIt<DatabaseHelper>(instanceName: 'prod').db;
      for (final movie in movies) {
        await db.insert('movies', movie.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    // } catch (error) {
    //   throw 'Error storing data in the database: $error';
    // }
  }

  Future<List<Movie>> getCachedMoviesFromDatabase() async {
    //try {
      final db = await getIt<DatabaseHelper>(instanceName: 'prod').db;
      final List<Map<String, dynamic>> maps = await db.query('movies');
      return List.generate(maps.length, (i) {
        return Movie.fromJson(maps[i]);
      });
    // } catch (error) {
    //   throw 'Error retrieving data from the database: $error';
    // }
  }
}

import 'package:sqflite_common/sqlite_api.dart';

import '../../domain/model/movie.dart';

// class for handling business logic of DetailsScreen
class DetailsScreenVM {
  DetailsScreenVM(this._database);

  final Database _database;

  Future<void> toggleFavourite(Movie movie) async {
    List<Map<String, Object?>> maps = await getFavourites();
    List<Movie> favourites = List.generate(maps.length, (i) {
      return Movie.fromJson(maps[i]);
    });
    for (final fav in favourites) {
      if (movie.id == fav.id) {
        removeFavourite(movie);
        return;
      }
    }
    addFavourite(movie);
  }

  Future<void> addFavourite(Movie movie) async {
    await _database.insert('favourite_movies', movie.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavourite(Movie movie) async {
    await _database
        .delete('favourite_movies', where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<List<Map<String, Object?>>> getFavourites() {
    return _database.query('favourite_movies');
  }
}

import 'package:sqflite/sqflite.dart';

import '../../domain/model/movie.dart';

class FavouritesScreenVM {
  FavouritesScreenVM(this._database);

  final Database _database;

  Future<List<Movie>> getFavourites() async {
    List<Map<String, Object?>> maps = await _database.query('favourite_movies');
    List<Movie> favourites = List.generate(maps.length, (i) {
      return Movie.fromJson(maps[i]);
    });

    return favourites;
  }
}

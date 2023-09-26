import 'package:dio/dio.dart';

import '../model/popular_movie_response.dart';

class MoviesScreenRepo {
  MoviesScreenRepo({required Dio dio});

  Future<PopularMovieResponse> getTrending(dio) async {
    final response = await dio.get(
      'movie/popular/',
      queryParameters: {'api_key': 'd7b3a200b2f3a0a78c4b048924ff28f8'},
    );

    if (response.statusCode == 200) {
      return PopularMovieResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}

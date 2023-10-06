import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioService {
  final options = BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3/',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  late final Dio _dio = Dio(options);

  Dio get dio {
    return _dio;
  }
}

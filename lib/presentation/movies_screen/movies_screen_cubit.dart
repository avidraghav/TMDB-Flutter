import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/movie.dart';

class MoviesScreenCubit extends Cubit<MoviesScreenState> {
  MoviesScreenCubit() : super(const MoviesScreenState(
            isLoading: true, movies: [], currentPage: 0));

  void setLoadingState(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  void setMovies(List<Movie> movies) {
    emit(state.copyWith(movies: movies));
  }

  void setErrorMessage(String message) {
    emit(state.copyWith(errorMessage: message));
  }

  void setCurrentPage(double value) {
    emit(state.copyWith(currentPage: value));
  }
}

class MoviesScreenState {
  final bool isLoading;
  final List<Movie> movies;
  final String? errorMessage;
  final double currentPage;

  const MoviesScreenState({
    required this.isLoading,
    required this.movies,
    this.errorMessage,
    required this.currentPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoviesScreenState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          movies == other.movies &&
          errorMessage == other.errorMessage &&
          currentPage == other.currentPage);

  @override
  int get hashCode =>
      isLoading.hashCode ^
      movies.hashCode ^
      errorMessage.hashCode ^
      currentPage.hashCode;

  @override
  String toString() {
    return 'MoviesScreenState{' +
        ' isLoading: $isLoading,' +
        ' movies: $movies,' +
        ' errorMessage: $errorMessage,' +
        ' currentPage: $currentPage,' +
        '}';
  }

  MoviesScreenState copyWith({
    bool? isLoading,
    List<Movie>? movies,
    String? errorMessage,
    double? currentPage,
  }) {
    return MoviesScreenState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLoading': this.isLoading,
      'movies': this.movies,
      'errorMessage': this.errorMessage,
      'currentPage': this.currentPage,
    };
  }

  factory MoviesScreenState.fromMap(Map<String, dynamic> map) {
    return MoviesScreenState(
      isLoading: map['isLoading'] as bool,
      movies: map['movies'] as List<Movie>,
      errorMessage: map['errorMessage'] as String,
      currentPage: map['currentPage'] as double,
    );
  }

//</editor-fold>
}

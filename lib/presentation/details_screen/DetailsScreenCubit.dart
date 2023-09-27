import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/movie.dart';

class DetailsScreenCubit extends Cubit<DetailsScreenState> {
  DetailsScreenCubit(DetailsScreenState initialState) : super(initialState);

  void toggleFavourite() {
    emit(state.copyWith(isFavourite: !state.isFavourite));
  }
}

class DetailsScreenState {
  final Movie? movie;
  final bool isFavourite;

  const DetailsScreenState({
    required this.movie,
    this.isFavourite = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetailsScreenState &&
          runtimeType == other.runtimeType &&
          movie == other.movie &&
          isFavourite == other.isFavourite);

  @override
  int get hashCode => movie.hashCode ^ isFavourite.hashCode;

  @override
  String toString() {
    return 'DetailsScreenState{ movie: $movie, isFavourite: $isFavourite,}';
  }

  DetailsScreenState copyWith({
    Movie? movie,
    bool? isFavourite,
  }) {
    return DetailsScreenState(
      movie: movie ?? this.movie,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movie': movie,
      'isFavourite': isFavourite,
    };
  }

  factory DetailsScreenState.fromMap(Map<String, dynamic> map) {
    return DetailsScreenState(
      movie: map['movie'] as Movie,
      isFavourite: map['isFavourite'] as bool,
    );
  }
}

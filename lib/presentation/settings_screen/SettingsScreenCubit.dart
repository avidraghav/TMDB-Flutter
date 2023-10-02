import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreenCubit extends Cubit<SettingsScreenState> {
  SettingsScreenCubit(SettingsScreenState initialState) : super(initialState);

  void toggleTheme() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}

class SettingsScreenState {
  final bool isDarkMode;

  const SettingsScreenState({
    this.isDarkMode = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsScreenState &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode);

  @override
  int get hashCode => isDarkMode.hashCode;

  @override
  String toString() {
    return 'SettingsScreenState{' + ' isDarkMode: $isDarkMode,' + '}';
  }

  SettingsScreenState copyWith({
    bool? isDarkMode,
  }) {
    return SettingsScreenState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': this.isDarkMode,
    };
  }

  factory SettingsScreenState.fromMap(Map<String, dynamic> map) {
    return SettingsScreenState(
      isDarkMode: map['isDarkMode'] as bool,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  AuthScreenCubit(super.initialState);

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }
}

class AuthScreenState {
  final String? email;
  final String? password;
  final bool isLoading;

  const AuthScreenState({
    this.email,
    this.password,
    this.isLoading = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthScreenState &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          isLoading == other.isLoading);

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ isLoading.hashCode;

  @override
  String toString() {
    return 'AuthScreenState{ email: $email, password: $password, isLoading: $isLoading,}';
  }

  AuthScreenState copyWith({
    String? email,
    String? password,
    bool? isLoading,
  }) {
    return AuthScreenState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'isLoading': isLoading,
    };
  }

  factory AuthScreenState.fromMap(Map<String, dynamic> map) {
    return AuthScreenState(
      email: map['email'] as String,
      password: map['password'] as String,
      isLoading: map['isLoading'] as bool,
    );
  }
}

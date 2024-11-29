/*
Auth states
*/

abstract class AuthState {}

// initial
class AuthInitial extends AuthState {}

// loading
class AuthLoading extends AuthState {}

// authenticated
class Authenticated<T> extends AuthState {
  final T user;
  Authenticated(this.user);
}

// unathenticated
class Unauthenticated extends AuthState {}

// error handling
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

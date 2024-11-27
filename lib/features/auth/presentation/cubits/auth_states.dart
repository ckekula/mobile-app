/*
Auth states
*/

import 'package:mobile_app/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

// initial
class AuthInitial extends AuthState {}

// loading
class AuthLoading extends AuthState {}

// authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

// unathenticated
class Unauthenticated extends AuthState {}

// error handling
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

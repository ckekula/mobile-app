/*
Auth states
*/

import 'package:mobile_app/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

class UserAuthInitial extends AuthState {}

class UserAuthLoading extends AuthState {}

class UserAuthenticated extends AuthState {
  final AppUser user;
  UserAuthenticated(this.user);
}

class UserUnauthenticated extends AuthState {}

class UserAuthError extends AuthState {
  final String message;
  UserAuthError(this.message);
}

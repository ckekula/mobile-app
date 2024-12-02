/*

Profile States

*/

import 'package:mobile_app/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileState {}

// initial
class UserProfileInitial extends UserProfileState {}

// loading
class UserProfileLoading extends UserProfileState {}

// loaded
class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;
  UserProfileLoaded(this.userProfile);
}

// error
class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}

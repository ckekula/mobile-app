/*

profile repository

*/

import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo{
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser profileUser);
}
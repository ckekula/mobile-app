import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';
import 'package:mobile_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{
  Future<ProfileUser?> fetchUserProfile(String uid) {
    // TODO: implement fetchUserProfile
    throw UnimplementedError();
  }

  Future<void> updateProfile(ProfileUser updatedProfile) {
    // TODO: implement updatedProfile
    throw UnimplementedError();
  }
}
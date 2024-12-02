import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/profile/domain/repos/profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/user_profile_states.dart';
import 'package:mobile_app/features/storage/domain/storage_repo.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  UserProfileCubit({required this.storageRepo, required this.profileRepo})
      : super(UserProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(UserProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(UserProfileLoaded(user));
      } else {
        emit(UserProfileError("User not found"));
      }
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  // update bio or profile picture
  Future<void> updateProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    emit(UserProfileLoading());

    try {
      // feth the current user
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(UserProfileError("Failed to fetch user for profle update"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;

      //ensue thare is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if (imageMobilePath != null) {
          //upload
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        //for web
        else if (imageWebBytes != null) {
          //upload
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(UserProfileError("Failed to upload image"));
          return;
        }
      }

      // update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // update in repo
      await profileRepo.updateUserProfile(updatedProfile);

      // refetch the uploaded profile
      await fetchUserProfile(uid);

      // update bio
    } catch (e) {
      emit(UserProfileError("Error updating profile: $e"));
    }
  }
}

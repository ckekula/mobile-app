import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/profile/domain/repos/profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:mobile_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.storageRepo, required this.profileRepo})
      : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // update bio or profile picture
  Future<void> updateProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    emit(ProfileLoading());

    try {
      // feth the current user
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profle update"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;

      //ensue thare is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if(imageMobilePath != null) {
          //upload
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        //for web
        else if(imageWebBytes != null){
          //upload
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if(imageDownloadUrl != null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }

      // update new profile
      final updatedProfile =
          currentUser.copyWith(
            newBio: newBio ?? currentUser.bio,
            newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,);

      // update in repo
      await profileRepo.updateProfile(updatedProfile);

      // refetch the uploaded profile
      await fetchUserProfile(uid);

      // update bio
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}

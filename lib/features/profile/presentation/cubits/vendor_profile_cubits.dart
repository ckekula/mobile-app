import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';
import 'package:mobile_app/features/profile/domain/repos/profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_states.dart';
import 'package:mobile_app/features/storage/domain/storage_repo.dart';

class VendorProfileCubit extends Cubit<VendorProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  VendorProfileCubit({required this.storageRepo, required this.profileRepo})
      : super(VendorProfileInitial());

  // fetch vendor profile using repo
  Future<void> fetchVendorProfile(String uid) async {
    try {
      emit(VendorProfileLoading());
      final vendor = await profileRepo.fetchVendorProfile(uid);

      if (vendor != null) {
        emit(VendorProfileLoaded(vendor));
      } else {
        emit(VendorProfileError("Vendor not found"));
      }
    } catch (e) {
      emit(VendorProfileError(e.toString()));
    }
  }

  // return vendor profile given uid -> for loading many profiles for posts
  Future<VendorProfile?> getVendorProfile(String uid) async {
    final vendor = await profileRepo.fetchVendorProfile(uid);
    return vendor;
  }

  // update bio or profile picture
  Future<void> updateProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    emit(VendorProfileLoading());

    try {
      // feth the current user
      final currentVendor = await profileRepo.fetchVendorProfile(uid);

      if (currentVendor == null) {
        emit(VendorProfileError("Failed to fetch vendor for profle update"));
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
          emit(VendorProfileError("Failed to upload image"));
          return;
        }
      }

      // update new profile
      final updatedVendorProfile = currentVendor.copyWith(
        newBio: newBio ?? currentVendor.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentVendor.profileImageUrl,
      );

      // update in repo
      await profileRepo.updateVendorProfile(updatedVendorProfile);

      // refetch the uploaded profile
      await fetchVendorProfile(uid);

      // update bio
    } catch (e) {
      emit(VendorProfileError("Error updating profile: $e"));
    }
  }

  // toggle follow/unfollow
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
    } catch (e) {
      emit(VendorProfileError("Error toggling follow: $e"));
    }
  }
}

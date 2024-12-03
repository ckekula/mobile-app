/*

profile repository

*/

import 'package:mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';

abstract class ProfileRepo {
  Future<UserProfile?> fetchUserProfile(String uid);
  Future<VendorProfile?> fetchVendorProfile(String uid);
  Future<void> updateUserProfile(UserProfile profileUser);
  Future<void> updateVendorProfile(VendorProfile profileVendor);
  Future<void> toggleFollow(String currentUid, String targetUid);
}

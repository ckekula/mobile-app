import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';
import 'package:mobile_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserProfile?> fetchUserProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return UserProfile(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile updatedUserProfile) async {
    try {
      // convert updated profile -> json to store in firebase
      await firebaseFirestore
          .collection('users')
          .doc(updatedUserProfile.uid)
          .update({
        'bio': updatedUserProfile.bio,
        'profileImageUrl': updatedUserProfile.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<VendorProfile?> fetchVendorProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return VendorProfile(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateVendorProfile(VendorProfile updatedVendorProfile) async {
    try {
      // convert updated profile -> json to store in firebase
      await firebaseFirestore
          .collection('users')
          .doc(updatedVendorProfile.uid)
          .update({
        'bio': updatedVendorProfile.bio,
        'profileImageUrl': updatedVendorProfile.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}

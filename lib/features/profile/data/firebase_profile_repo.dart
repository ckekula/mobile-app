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
          // fetch following
          final following = List<String>.from(userData['following'] ?? []);

          return UserProfile(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            following: following,
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
          await firebaseFirestore.collection('vendors').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return VendorProfile(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: List<String>.from(userData['followers']),
          );
        }
      }

      return null;
    } catch (e) {
      print("Error fetching vendor profile: $e");
      return null;
    }
  }

  @override
  Future<void> updateVendorProfile(VendorProfile updatedVendorProfile) async {
    try {
      // convert updated profile -> json to store in firebase
      await firebaseFirestore
          .collection('vendors')
          .doc(updatedVendorProfile.uid)
          .update({
        'bio': updatedVendorProfile.bio,
        'profileImageUrl': updatedVendorProfile.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetVendorDoc =
          await firebaseFirestore.collection('vendors').doc(targetUid).get();

      if (currentUserDoc.exists && targetVendorDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final List<String> currentFollowing =
            List<String>.from(currentUserData?['following'] ?? []);

        if (currentFollowing.contains(targetUid)) {
          // unfollow
          await firebaseFirestore.collection('users').doc(currentUid).update({
            'following': FieldValue.arrayRemove([targetUid])
          });
          await firebaseFirestore.collection('vendors').doc(targetUid).update({
            'followers': FieldValue.arrayRemove([currentUid])
          });
        } else {
          // follow
          await firebaseFirestore.collection('users').doc(currentUid).update({
            'following': FieldValue.arrayUnion([targetUid])
          });
          await firebaseFirestore.collection('vendors').doc(targetUid).update({
            'followers': FieldValue.arrayUnion([currentUid])
          });
        }
      }
    } catch (e) {
      return;
    }
  }
}

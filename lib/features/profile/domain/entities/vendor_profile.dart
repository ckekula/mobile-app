import 'package:mobile_app/features/auth/domain/entities/app_Vendor.dart';

class VendorProfile extends AppVendor {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;

  VendorProfile(
      {required super.uid,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.followers});

  // method to update profile vendor
  VendorProfile copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
  }) {
    return VendorProfile(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newFollowers ?? followers,
    );
  }

  // convert profile vendor -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers
    };
  }

  // convert json -> profile vendor
  factory VendorProfile.fromJson(Map<String, dynamic> json) {
    return VendorProfile(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      followers: List<String>.from(json['followers']),
    );
  }
}

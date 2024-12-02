import 'package:mobile_app/features/auth/domain/entities/app_Vendor.dart';

class ProfileVendor extends AppVendor {
  final String bio;
  final String profileImageUrl;

  ProfileVendor(
      {required super.uid,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl});

  // method to update profile vendor
  ProfileVendor copyWith({
    String? newBio,
    String? newProfileImageUrl,
  }) {
    return ProfileVendor(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
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
      'profileImageUrl': profileImageUrl
    };
  }

  // convert json -> profile vendor
  factory ProfileVendor.fromJson(Map<String, dynamic> json) {
    return ProfileVendor(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}

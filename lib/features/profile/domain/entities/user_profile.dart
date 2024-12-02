import 'package:mobile_app/features/auth/domain/entities/app_user.dart';

class UserProfile extends AppUser {
  final String bio;
  final String profileImageUrl;

  UserProfile(
      {required super.uid,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl});

  // method to update profile user
  UserProfile copyWith({
    String? newBio,
    String? newProfileImageUrl,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  // convert user profile -> json
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

  // convert json -> user profile
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}

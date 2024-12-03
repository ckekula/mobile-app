import 'package:mobile_app/features/auth/domain/entities/app_user.dart';

class UserProfile extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> following;

  UserProfile(
      {required super.uid,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.following});

  // method to update profile user
  UserProfile copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowing,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      following: newFollowing ?? following,
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
      'profileImageUrl': profileImageUrl,
      'following': following,
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
        following: List<String>.from(json['following']));
  }
}

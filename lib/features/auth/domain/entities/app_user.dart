class AppUser {
  final String uid;
  final String email;
  final String name;

  // constructor
  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert app user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  // convert app user -> json
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
    );
  }
}

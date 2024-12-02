class AppVendor {
  final String uid;
  final String email;
  final String name;

  // constructor
  AppVendor({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert app vendor -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  // convert app vendor -> json
  factory AppVendor.fromJson(Map<String, dynamic> jsonVendor) {
    return AppVendor(
      uid: jsonVendor['uid'],
      email: jsonVendor['email'],
      name: jsonVendor['name'],
    );
  }
}

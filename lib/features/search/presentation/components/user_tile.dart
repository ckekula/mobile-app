import 'package:flutter/material.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';

class UserTile extends StatelessWidget {
  final VendorProfile vendor;

  const UserTile({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vendor.name),
      subtitle: Text(vendor.email),
    );
  }
}

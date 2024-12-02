/*

Profile States

*/

import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';

abstract class VendorProfileState {}

// initial
class VendorProfileInitial extends VendorProfileState {}

// loading
class VendorProfileLoading extends VendorProfileState {}

// loaded
class VendorProfileLoaded extends VendorProfileState {
  final VendorProfile vendorProfile;
  VendorProfileLoaded(this.vendorProfile);
}

// error
class VendorProfileError extends VendorProfileState {
  final String message;
  VendorProfileError(this.message);
}

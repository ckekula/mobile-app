/*
Auth states
*/

import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';

abstract class VendorAuthState {}

class VendorAuthInitial extends VendorAuthState {}

class VendorAuthLoading extends VendorAuthState {}

class VendorAuthenticated extends VendorAuthState {
  final AppVendor vendor;
  VendorAuthenticated(this.vendor);
}

class VendorUnauthenticated extends VendorAuthState {}

class VendorAuthError extends VendorAuthState {
  final String message;
  VendorAuthError(this.message);
}

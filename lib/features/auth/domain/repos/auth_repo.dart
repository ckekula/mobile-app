/*
Auth Repo - Outlines the possible auth operations for this app
*/

import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);
  Future<AppVendor?> loginVendorWithEmailPassword(
      String email, String password);
  Future<AppVendor?> registerVendorWithEmailPassword(
      String name, String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<AppVendor?> getCurrentVendor();
}

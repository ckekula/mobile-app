/*
Auth Repo - Outlines the possible auth operations for this app
*/

// accepts a generic type T which can be AppUser or AppVendor
abstract class AuthRepo<T> {
  Future<T?> loginWithEmailPassword(String email, String password);
  Future<T?> registerWithEmailPassword(
      String name, String email, String password);
  Future<void> logout();
  Future<T?> getCurrentUser();
}

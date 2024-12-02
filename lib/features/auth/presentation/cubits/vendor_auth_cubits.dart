/*
Auth cubit: State management
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/domain/repos/auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_states.dart';

class VendorAuthCubit extends Cubit<VendorAuthState> {
  final AuthRepo authRepo;
  AppVendor? _currentVendor;

  VendorAuthCubit({required this.authRepo}) : super(VendorAuthInitial());

  // check if user is authenticated
  void checkAuth() async {
    final AppVendor? user = await authRepo.getCurrentVendor();

    if (user != null) {
      _currentVendor = user;
      emit(VendorAuthenticated(user));
    } else {
      emit(VendorUnauthenticated());
    }
  }

  // get the current user
  AppVendor? get currentUser => _currentVendor;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(VendorAuthLoading());
      final user = await authRepo.loginVendorWithEmailPassword(email, password);

      if (user != null) {
        _currentVendor = user;
        emit(VendorAuthenticated(user));
      } else {
        emit(VendorUnauthenticated());
      }
    } catch (e) {
      emit(VendorAuthError(e.toString()));
      emit(VendorUnauthenticated());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(VendorAuthLoading());
      final user =
          await authRepo.registerVendorWithEmailPassword(name, email, password);

      if (user != null) {
        _currentVendor = user;
        emit(VendorAuthenticated(user));
      } else {
        emit(VendorUnauthenticated());
      }
    } catch (e) {
      emit(VendorAuthError(e.toString()));
      emit(VendorUnauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepo.logout();
    emit(VendorUnauthenticated());
  }
}

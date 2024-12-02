/*
Auth cubit: State management
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/repos/auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(UserAuthInitial());

  // check if user is authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(UserAuthenticated(user));
    } else {
      emit(UserUnauthenticated());
    }
  }

  // get the current user
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(UserAuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(UserAuthenticated(user));
      } else {
        emit(UserUnauthenticated());
      }
    } catch (e) {
      emit(UserAuthError(e.toString()));
      emit(UserUnauthenticated());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(UserAuthLoading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(UserAuthenticated(user));
      } else {
        emit(UserUnauthenticated());
      }
    } catch (e) {
      emit(UserAuthError(e.toString()));
      emit(UserUnauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepo.logout();
    emit(UserUnauthenticated());
  }
}

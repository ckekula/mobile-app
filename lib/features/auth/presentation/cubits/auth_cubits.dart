/*
Auth cubit: State management
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/repos/auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit<T> extends Cubit<AuthState> {
  final AuthRepo authRepo;
  T? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // check if user is authenticated
  void checkAuth() async {
    final T? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get the current user
  T? get currentUser => _currentUser;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }
}

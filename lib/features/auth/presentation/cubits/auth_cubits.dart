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

  /*
  Check if the user is authenticated or not.
  
  If the user is authenticated, save the user and emit [Authenticated] state.
  If the user is not authenticated, emit [Unauthenticated] state.
  */
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

  /*
  Login with email and password
    
  If login is successful, save the user and emit [Authenticated] state.
  If login fails, emit [Unauthenticated] state.
  
  If an exception occurs, catch it and emit [AuthError] state.
  */
  Future<void> login(String email, String password) async {
    print("AuthCubit.login($email, $password)");
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      print("AuthCubit.login: user=$user");

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      print("AuthCubit.login: error=$e");
      emit(AuthError("Login failed: ${e.toString()}"));
      emit(Unauthenticated());
    }
  }

  /*
  Register with email and password
    
  If registration is successful, save the user and emit [Authenticated] state.
  If registration fails, emit [Unauthenticated] states.
  
  If an exception occurs, catch it and emit [AuthError] states.
  */
  Future<void> register(String name, String email, String password) async {
    print("AuthCubit.register($name, $email, $password)");
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);

      print("AuthCubit.register: user=$user");

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      print("AuthCubit.register: error=$e");
      emit(AuthError("Register failed: ${e.toString()}"));
      emit(Unauthenticated());
    }
  }

  /*
  Logout the current user.
  
  Emits [AuthLoading] initially.
  
  If logout is successful, emits [Unauthenticated] state.
  If logout fails, emits [AuthError]
  */
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Logout failed: ${e.toString()}"));
    }
  }
}

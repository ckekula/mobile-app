/* 
App- root level

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (loh=gin?register)
  - authenticated -> home page

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/data/firebase_auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'themes/light_mode.dart';

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            // unauthenticated -> auth page
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // authenticated -> home page
            if (authState is Authenticated) {
              return const HomePage();
            }

            // loading
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },

          // listen for errors
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}

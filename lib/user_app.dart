/* 
App-root level

uses a [MultiBlocProvider] to provide the following [Bloc]s to its subtree:

1. [AuthCubit] for user authentication
2. [ProfileCubit] for profile management

The [MaterialApp] is the top-most widget in the subtree. It provides a
[Navigator] which is used to navigate between the different pages of the
application.

The home page of the [MaterialApp] is a [BlocConsumer] which listens to the
[AuthState] of the user and vendor authentication [Bloc]s. Depending on the
authentication state, it navigates to the [HomePage] or the [AuthPage].
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/data/firebase_auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/profile/data/firebase_profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/user_profile_cubits.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_cubits.dart';
import 'package:mobile_app/features/search/data/firebase_search_repo.dart';
import 'package:mobile_app/features/search/presentation/cubits/search_states.dart';
import 'package:mobile_app/features/storage/data/firebase_storage_repo.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/post/data/firebase_post_repo.dart';
import 'features/post/presentation/cubits/post_cubit.dart';
import 'themes/light_mode.dart';

class UserApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  //post repo
  final firebasePostRepo = FirebasePostRepo();

  final VoidCallback switchToVendorApp;

  UserApp({super.key, required this.switchToVendorApp});

  // main application widget.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        // vendor auth cubit
        BlocProvider(
          create: (context) =>
              VendorAuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        // user profile cubit
        BlocProvider<UserProfileCubit>(
          create: (context) => UserProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),
        // vendor profile cubit
        BlocProvider<VendorProfileCubit>(
          create: (context) => VendorProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),
        // post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        // search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            searchRepo: firebaseSearchRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            // unauthenticated -> auth page
            if (authState is UserUnauthenticated) {
              return AuthPage(switchToVendorApp: switchToVendorApp);
            }

            // authenticated -> home page
            if (authState is UserAuthenticated) {
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
            if (state is UserAuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}

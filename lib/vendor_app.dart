/* 
vendor app

uses a [MultiBlocProvider] to provide the following [Bloc]s to its subtree:

1. [AuthCubit] for user authentication
2. [ProfileCubit] for profile management

The [MaterialApp] is the top-most widget in the subtree. It provides a
[Navigator] which is used to navigate between the different pages of the
application.

The home page of the [MaterialApp] is a [BlocConsumer] which listens to the
[AuthState] of the vendor authentication [Bloc]s. Depending on the authentication
state, it navigates to the [HomePage] or the [AuthPage].
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/data/firebase_auth_repo.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_states.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_auth_page.dart';
import 'package:mobile_app/features/post/data/firebase_post_repo.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:mobile_app/features/profile/data/firebase_profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/user_profile_cubits.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_cubits.dart';
import 'package:mobile_app/features/search/data/firebase_search_repo.dart';
import 'package:mobile_app/features/search/presentation/cubits/search_states.dart';
import 'package:mobile_app/features/storage/data/firebase_storage_repo.dart';
import 'package:mobile_app/themes/theme_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';

class VendorApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  final VoidCallback switchToUserApp;

  VendorApp({super.key, required this.switchToUserApp});

  // main application widget.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // vendor auth cubit
        BlocProvider(
          create: (context) =>
              VendorAuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        // auth cubit
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        // vendor profile cubit
        BlocProvider<VendorProfileCubit>(
          create: (context) => VendorProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),
        // user profile cubit
        BlocProvider<UserProfileCubit>(
          create: (context) => UserProfileCubit(
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
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        // theme cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,

          // bloc consumer - check vendor auth state
          home: BlocConsumer<VendorAuthCubit, VendorAuthState>(
            builder: (context, authState) {
              print(authState);
              // unauthenticated -> auth page
              if (authState is VendorUnauthenticated) {
                return VendorAuthPage(switchToUserApp: switchToUserApp);
              }

              // authenticated -> home page
              if (authState is VendorAuthenticated) {
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
              if (state is VendorAuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}

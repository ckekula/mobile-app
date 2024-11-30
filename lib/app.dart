/* 
App-root level

uses a [MultiBlocProvider] to provide the following [Bloc]s to its subtree:

1. [AuthCubit] for user authentication
2. [AuthCubit] for vendor authentication
3. [ProfileCubit] for profile management

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
import 'package:mobile_app/features/auth/data/firebase_vendor_auth_repo.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:mobile_app/features/profile/data/firebase_profile_repo.dart';
import 'package:mobile_app/features/profile/presentation/cubits/profile_cubits.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'themes/light_mode.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  final vendorAuthRepo = FirebaseVendorAuthRepo();
  final profileRepo = FirebaseProfileRepo();

  MyApp({super.key});

  // main application widget.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit<AppUser>>(
          create: (context) =>
              AuthCubit<AppUser>(authRepo: authRepo)..checkAuth(),
        ),
        BlocProvider<AuthCubit<AppVendor>>(
          create: (context) =>
              AuthCubit<AppVendor>(authRepo: vendorAuthRepo)..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit<AppUser>, AuthState>(
          listener: (context, userAuthState) {
            print("User auth state changed: $userAuthState");
            if (userAuthState is Authenticated<AppUser>) {
              print("User authenticated: ${userAuthState.user}");
            } else if (userAuthState is Unauthenticated) {
              print("User unauthenticated.");
            }
          },
          builder: (context, userAuthState) {
            return BlocConsumer<AuthCubit<AppVendor>, AuthState>(
              listener: (context, vendorAuthState) {
                print("Vendor auth state changed: $vendorAuthState");
                if (vendorAuthState is Authenticated<AppVendor>) {
                  print("Vendor authenticated: ${vendorAuthState.user}");
                } else if (vendorAuthState is Unauthenticated) {
                  print("Vendor unauthenticated.");
                }
              },
              builder: (context, vendorAuthState) {
                if (userAuthState is Authenticated<AppUser>) {
                  print("user is authenticated. navigate to HomePage.");
                  return const HomePage();
                }
                if (vendorAuthState is Authenticated<AppVendor>) {
                  print("vendor is authenticated. navigate to HomePage.");
                  return const HomePage();
                }
                if (userAuthState is Unauthenticated &&
                    vendorAuthState is Unauthenticated) {
                  print(
                      "user and vendor are unauthenticated. navigate to AuthPage.");
                  return const AuthPage();
                }
                print("Showing loading indicator.");
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

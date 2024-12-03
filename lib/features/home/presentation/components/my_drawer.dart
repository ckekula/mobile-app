import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_states.dart';
import 'package:mobile_app/features/home/presentation/components/my_drawer_tile.dart';
import 'package:mobile_app/features/profile/presentation/pages/user_profile_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/vendor_profile_page.dart';
import 'package:mobile_app/features/search/presentation/pages/search_page.dart';
import 'package:mobile_app/features/settings/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // Divider line
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),

              // home tile
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              // profile tile
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.of(context).pop();

                  // get current user id
                  final authState = context.read<AuthCubit>().state;
                  final vendorAuthState = context.read<VendorAuthCubit>().state;

                  // regular user -> UserProfilePage
                  if (authState is UserAuthenticated) {
                    print("user auth state: $authState");
                    print("vendor auth state: $vendorAuthState");
                    print("Navigating to user profile page");
                    final user = authState.user;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(uid: user.uid),
                      ),
                    );
                  }
                  // vendor -> VendorProfilePage
                  else if (vendorAuthState is VendorAuthenticated) {
                    print("user auth state: $authState");
                    print("vendor auth state: $vendorAuthState");
                    print("Navigating to user profile page");
                    final vendor = vendorAuthState.vendor;
                    print(vendor.name);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VendorProfilePage(uid: vendor.uid),
                      ),
                    );
                  }
                },
              ),

              // search tile
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage())),
              ),

              // setting tile
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
              ),

              const Spacer(),

              // logout tile
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.login,
                onTap: () {
                  // get current user id
                  final authState = context.read<AuthCubit>().state;
                  final vendorAuthState = context.read<VendorAuthCubit>().state;

                  // regular user -> UserProfilePage
                  if (authState is UserAuthenticated) {
                    context.read<AuthCubit>().logout();
                  }
                  // vendor -> VendorProfilePage
                  else if (vendorAuthState is VendorAuthenticated) {
                    context.read<VendorAuthCubit>().logout();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

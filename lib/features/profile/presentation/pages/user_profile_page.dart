import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/profile/presentation/components/bio_box.dart';
import 'package:mobile_app/features/profile/presentation/cubits/user_profile_cubits.dart';
import 'package:mobile_app/features/profile/presentation/cubits/user_profile_states.dart';
import 'package:mobile_app/features/profile/presentation/pages/edit_user_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;

  const UserProfilePage({super.key, required this.uid});

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<UserProfileCubit>();

  // curent user
  late AppUser? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
      // loaded
      if (state is UserProfileLoaded) {
        // get loaded user
        final user = state.userProfile;

        // SCAFFOLD
        return Scaffold(
          // APP BAR
          appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // edit profile button
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user)),
                  ),
                  icon: const Icon(Icons.settings),
                )
              ]),

          // BODY
          body: Column(
            children: [
              // email
              Text(
                user.email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 25),

              // profile pic
              CachedNetworkImage(
                imageUrl: user.profileImageUrl,
                //loading
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),

                //error failed to load
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),

                //loaded
                imageBuilder: (context, imageProvider) => Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // bio box
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: [
                    Text("Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              BioBox(text: user.bio),

              // posts
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                child: Row(
                  children: [
                    Text("Pio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      // loading
      else if (state is UserProfileLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Center(
          child: Text("No profile found!"),
        );
      }
    });
  }
}

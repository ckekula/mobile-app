import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/profile/presentation/components/bio_box.dart';
import 'package:mobile_app/features/profile/presentation/components/follow_button.dart';
import 'package:mobile_app/features/profile/presentation/components/vendor_profile_stats.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_cubits.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_states.dart';
import 'package:mobile_app/features/profile/presentation/pages/edit_vendor_profile_page.dart';

class VendorProfilePage extends StatefulWidget {
  final String uid;

  const VendorProfilePage({super.key, required this.uid});

  @override
  State<VendorProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<VendorProfilePage> {
  // cubits
  late final authCubit = context.read<VendorAuthCubit>();
  late final profileCubit = context.read<VendorProfileCubit>();

  // curent user
  late AppVendor? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchVendorProfile(widget.uid);
  }

  /*
  FOLLOW / UNFOLLOW
  */

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! VendorProfileLoaded) {
      return; // return if profile is mnot loaded
    }

    final vendorProfile = profileState.vendorProfile;
    final isFollowing = vendorProfile.followers.contains(currentUser!.uid);

    // optimistically update the UI
    setState(() {
      // unfollow
      if (isFollowing) {
        vendorProfile.followers.remove(currentUser!.uid);
      }
      // follow
      else {
        vendorProfile.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert update if there is an error
      setState(() {
        // unfollow
        if (isFollowing) {
          vendorProfile.followers.add(currentUser!.uid);
        }
        // follow
        else {
          vendorProfile.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // is own post
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<VendorProfileCubit, VendorProfileState>(
        builder: (context, state) {
      // loaded
      if (state is VendorProfileLoaded) {
        // get loaded vendor
        final vendor = state.vendorProfile;

        // SCAFFOLD
        return Scaffold(
          // APP BAR
          appBar: AppBar(
              title: Text(vendor.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // edit profile button
                if (isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditVendorProfilePage(user: vendor)),
                    ),
                    icon: const Icon(Icons.settings),
                  )
              ]),

          // BODY
          body: Column(
            children: [
              // email
              Text(
                vendor.email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 25),

              // profile pic
              CachedNetworkImage(
                imageUrl: vendor.profileImageUrl,
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

              // profile stats
              VendorProfileStats(
                  postCount: 0, // replace with postCount
                  followerCount: vendor.followers.length),

              const SizedBox(height: 25),

              // follow button
              if (isOwnPost)
                FollowButton(
                  onPressed: followButtonPressed,
                  isFollowing: vendor.followers.contains(currentUser!.uid),
                ),

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

              BioBox(text: vendor.bio),

              // posts
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                child: Row(
                  children: [
                    Text("Bio",
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
      else if (state is VendorProfileLoading) {
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

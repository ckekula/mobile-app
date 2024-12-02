import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';
import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';
import 'package:mobile_app/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:mobile_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //mobile image pick
  PlatformFile? imagepickedFile;

  //web image pick
  Uint8List? webimage;

  //bio text controller
  final bioTextController = TextEditingController();

  //pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,);

      if(result != null) {
        setState(() {
          imagepickedFile = result.files.first;

          if(kIsWeb){
            webimage = imagepickedFile!.bytes;
          }
        });

      }
    
  }

  // update profile button pressed
  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare image & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagepickedFile?.path;
    final imageWebBytes = kIsWeb ? imagepickedFile?.bytes : null;


    //only update profile if thare is somthing to update
    if (imagepickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }

    //nothing to update -> go to previous page
    else{
      Navigator.pop(context);
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
          return const Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Updating..."),
              ],
            ),
          ));
        } else {
          // edit form
          return buildEditPage();
        }

        // profile error
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Edit Profile"),
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              // save button
              IconButton(
                  onPressed: updateProfile, icon: const Icon(Icons.upload))
            ]),
        body: Column(
          children: [
            // profile picture
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,

                child:
                //display select image mobile
                (!kIsWeb && imagepickedFile != null)
                ?
                Image.file(File(imagepickedFile!.path!),
                fit: BoxFit.cover,)
                :

                //display selected image for web
                (kIsWeb && imagepickedFile != null)
                    ?
                    Image.memory(webimage!)
                    :

                    //no image select -> display existing image
                    CachedNetworkImage(
                      imageUrl: widget.user.profileImageUrl,
                      //loading
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),

                      //error failed to load
                      errorWidget: (context, url, error) =>  Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      //loaded
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
              ),
            ),

            const SizedBox(height: 25),

            //pick image button
            Center(
              child: MaterialButton(
                onPressed: pickImage ,
                color: Colors.blue,
                child: const Text("Pick Image"),
              ),
            ),

            // bio
            Text("Bio"),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MyTextField(
                  controller: bioTextController,
                  hintText: widget.user.bio,
                  obscureText: false),
            )
          ],
        ));
  }
}

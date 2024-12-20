import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_states.dart';
import 'package:mobile_app/themes/responsive/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile img pick
  PlatformFile? imagePickedFile;

  //web img pick
  Uint8List? webImage;

  //text controller -> caption
  final textController = TextEditingController();

  //current user
  AppVendor? currentVendor;

  @override
  void initState() {
    super.initState();

    getCurrentVendor();
  }

  //get current vendor
  void getCurrentVendor() {
    final vendorAuthCubit = context.read<VendorAuthCubit>();
    currentVendor = vendorAuthCubit.currentUser;

    // If not a vendor, navigate back
    if (currentVendor == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only vendors can create posts")),
      );
    }
  }

  //pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create & upload post
  void uploadPost() {
    //cheack image and caption both are provided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please provide both image and caption")));
    }

    //create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentVendor!.uid,
      userName: currentVendor!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    //web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }

    //mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    //BLOCK CONSUMER -> builder + listner
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      //loading or uploading
      if (state is PostsUploading || state is PostsUploading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      //build upload page
      return buildUploadPage();
    }, listener: (context, state) {
      if (state is PostsLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildUploadPage() {
    //SACFFOLD
    return ConstrainedScaffold(
      //APP BAR
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          )
        ],
      ),

      //BODY
      body: Center(
        child: Column(
          children: [
            //image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            //image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            //pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),

            //caption text field
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obscureText: false,
            )
          ],
        ),
      ),
    );
  }
}

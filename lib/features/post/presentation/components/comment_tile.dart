import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/post/domain/entities/comment.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //current user
  bool isOwnPost = false;

  // current user
  AppUser? currentUser;
  AppVendor? currentVendor;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  // Get either the current user or vendor depending on who is logged in
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    final vendorAuthCubit = context.read<VendorAuthCubit>();

    // Check if logged in as vendor
    currentVendor = vendorAuthCubit.currentUser;
    if (currentVendor != null) {
      setState(() {
        isOwnPost = (widget.comment.userId == currentVendor!.uid);
      });
      return;
    }

    // Check if logged in as user
    currentUser = authCubit.currentUser;
    if (currentUser != null) {
      setState(() {
        isOwnPost = false; // Users can never own posts
      });
      return;
    }

    // If neither user nor vendor is logged in, handle the null case
    setState(() {
      isOwnPost = false;
    });
  }

  //show option for deletion

  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Comment?"),
              actions: [
                //cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),

                //delete Button

                TextButton(
                    onPressed: () {
                      context.read<PostCubit>().deleteComment(
                          widget.comment.postId, widget.comment.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Delete"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: [
        //name
        Text(
          widget.comment.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        // comment text
        Text(widget.comment.text),

        const Spacer(),

        //delete button
        if (isOwnPost)
          GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ))
      ]),
    );
  }
}

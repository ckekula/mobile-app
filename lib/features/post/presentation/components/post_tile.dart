import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';
import 'package:mobile_app/features/post/domain/entities/comment.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_states.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';
import 'package:mobile_app/features/profile/presentation/cubits/vendor_profile_cubits.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //cubits
  late final postCubit = context.read<PostCubit>();
  late final vendorProfileCubit = context.read<VendorProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;
  AppVendor? currentVendor;

  //post user
  VendorProfile? postUser;

  //on startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostVendor();
  }

  // Get either the current user or vendor depending on who is logged in
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    final vendorAuthCubit = context.read<VendorAuthCubit>();

    // Check if logged in as vendor
    currentVendor = vendorAuthCubit.currentUser;
    if (currentVendor != null) {
      setState(() {
        isOwnPost = (widget.post.userId == currentVendor!.uid);
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

  Future<void> fetchPostVendor() async {
    final fetchedVendor =
        await vendorProfileCubit.getVendorProfile(widget.post.userId);
    if (fetchedVendor != null) {
      setState(() {
        postUser = fetchedVendor;
      });
    }
  }

  /*

  like

  */

  //user tapped like button
  void toggleLikePost() {
    // Get the current authenticated user's ID
    final String? currentUserId = currentUser?.uid ?? currentVendor?.uid;

    if (currentUserId == null) return;

    //current like status
    final isLiked = widget.post.likes.contains(currentUserId);

    //optimizitically like & update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUserId); //unlike
      } else {
        widget.post.likes.add(currentUserId); //like
      }
    });

    //update like
    postCubit.toggleLikePost(widget.post.id, currentUserId).catchError((error) {
      // if thare is an error , revert back to original value
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUserId); // revert unlike
        } else {
          widget.post.likes.remove(currentUserId); // revert like
        }
      });
    });
  }

  /*

  COMMENT

  */

  //comment text controller
  final commentTextController = TextEditingController();

  //open comment box -> user want to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
            controller: commentTextController,
            hintText: "Type a Comment",
            obscureText: false),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          //save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final String? currentUserId = currentUser?.uid ?? currentVendor?.uid;
    final String? currentUserName = currentUser?.email ?? currentVendor?.name;

    if (currentUserId == null || currentUserName == null) return;

    //create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUserId,
      userName: currentUserName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
      commentTextController.clear();
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // show option for deletion
  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post?"),
              actions: [
                //cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),

                //delete Button

                TextButton(
                    onPressed: () {
                      widget.onDeletePressed!();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Delete"))
              ],
            ));
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //Top section : profile pic/ name / delete button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //profile pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                const SizedBox(width: 10),

                //name
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                //delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
              ],
            ),
          ),

          //image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          //buttons -> like,comment,timstamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      //like button
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(
                                  currentUser?.uid ?? currentVendor?.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(
                                  currentUser?.uid ?? currentVendor?.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 5),
                      //like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                //comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 5),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                //timestamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),

          //caption
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: [
                // username
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 10),

                // text
                Text(widget.post.text),
              ],
            ),
          ),

          //comment section
          BlocBuilder<PostCubit, PostState>(builder: (context, state) {
            // loaded
            if (state is PostsLoaded) {
              //final individual post
              final post =
                  state.posts.firstWhere((post) => post.id == widget.post.id);
              if (post.comments.isNotEmpty) {
                // how many comments to show
                int showCommentCount = post.comments.length;

                //comment section
                return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];

                      //comment tile UI
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(children: [
                          //name
                          Text(
                            comment.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          // comment text
                          Text(comment.text),
                        ]),
                      );
                    });
              }
            }

            //loading
            if (state is PostsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //error
            else if (state is PostsError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }
}

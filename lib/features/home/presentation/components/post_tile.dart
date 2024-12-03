import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key, 
    required this.post,
    required this.onDeletePressed
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //show option for deletion
  void showOptions() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          //cancel Button
          TextButton(
            onPressed: ()=> Navigator.of(context).pop(), 
            child: const Text("Cancel")
          )

          //delete Button
          ,
          TextButton(
            onPressed: () {
              widget.onDeletePressed!;
              Navigator.of(context).pop();
            }, 
            child: const Text("Delete")
          )
        ],
      ));
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //name
            Text(widget.post.text),

            //delete button
            IconButton(
              onPressed: showOptions,
              icon: const Icon(Icons.delete),
            ),
          ],
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
      ],
    );
  }
}

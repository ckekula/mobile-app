import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/home/presentation/components/my_drawer.dart';
import 'package:mobile_app/features/home/presentation/components/post_tile.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_states.dart';
import 'package:mobile_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();

  //on startup
  @override
  void initState() {
    super.initState();

    //fetch all the posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(Post postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
        // APP BAR
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            //upload new post button
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  )),
              icon: const Icon(Icons.add),
            )
          ],
        ),

        //Drawer
        drawer: const MyDrawer(),

        // BODY
        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          //loading..
          if (state is PostsLoading && state is PostsUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No posts yet"),
              );
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get individual post
                final post = allPosts[index];

                //image
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post),
                );
              },
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
        }));
  }
}

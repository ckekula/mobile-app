import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/domain/repos/post_repo.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_states.dart';
import 'package:mobile_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  //create a new post
  Future<void> createPost(Post post,
    {String? imagePath, Uint8List? imageBytes}) async {
      String? imageUrl;
    
     try{
      //handle image upload for mobile platform(using file path)
     if(imagePath != null){
       emit(PostsUploading());
       imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
     }

      //handle image upload for web platform(using file path)
      else if(imageBytes != null){
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      //give img url to post
      final newPost = post.copywith(imageUrl: imageUrl);

      //create post in the backend
      postRepo.createPost(newPost);

      //re-fetch all the post
      fetchAllPosts();
    }
     catch(e){
      throw Exception("Error creating post: $e");
     }
    }

    //fetch all post
  Future<void> fetchAllPosts() async {
      try{
        emit(PostsLoading());
        final posts = await postRepo.fetchAllPosts();
        emit(PostsLoaded(posts));
      }
      catch(e){
        emit(PostsError("Failed to fetch posts: $e"));
      }
    }

    //delete post
  Future<void> deletePost(Post postId) async {
      try{
        await postRepo.deletePost(postId);
      }
      catch(e){
        throw Exception("Error deleting post: $e");
      }
    }
}
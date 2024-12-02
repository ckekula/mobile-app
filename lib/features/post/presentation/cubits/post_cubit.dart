import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/domain/repos/post_repo.dart';
import 'package:mobile_app/features/post/presentation/cubits/post_states.dart';
import 'package:mobile_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
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
    
     //handle image upload for mobile platform(using file path)
     if(imagePath != null){
       emit(PostsUploading());
       imageUrl = await storageRepo.uploadProfileImageMobile(imagePath,post.id);
     }

      //handle image upload for web platform(using file path)
      
    }
  }
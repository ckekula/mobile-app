import 'package:mobile_app/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(Post postId);
  Future<List<Post>> fetchPostsByUserId(String userId);
}
import 'package:mobile_app/features/post/domain/entities/comment.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(Post postId);
  Future<List<Post>> fetchPostsByVendorId(String userId);
  Future<void> toggleLikePost(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}

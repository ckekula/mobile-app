import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/features/post/domain/entities/comment.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store the posts in a collection called 'posts'
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override

  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(Post postId) async {
    await postCollection.doc(postId.id).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all post most recent post at the top
      final postSnapshots =
          await postCollection.orderBy('timestamp', descending: true).get();

      //convert each firstore document from json -> list of posts
      final List<Post> allposts = postSnapshots.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allposts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      //fetch post snapshots with this uid
      final postSnapshots =
          await postCollection.where("userId", isEqualTo: userId).get();

      //convert firstore document from json -> list of posts
      final userPosts = postSnapshots.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try{
      // get the posst document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if(postDoc.exists){
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //cheak if user has already like this post
        final hasLiked = post.likes.contains(userId);
         
        //update the like this
        if(hasLiked){
          post.likes.remove(userId);  //unlike
        }
        else{
          post.likes.add(userId); //like
        }

        //update the post document with the new like list
        await postCollection.doc(postId).update({
          'likes':post.likes,
        });
      }
      else{
        throw Exception("Post not found");
      }
    }
    catch(e){
      throw Exception("Error liking post: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try{
      //get the post document from firestore
      final postDoc =await postCollection.doc(postId).get();
      if(postDoc.exists){
        //convert json object -> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.add(comment);

        //update the post document in firstore
        await postCollection.doc(postId).update({
          'comments':post.comments.map((comment) => comment.toJson()).toList(),
        });
      }else{
        throw Exception("Post not found");
      }
    }
    catch(e){
      throw Exception("Error adding comment: $e");
    }
  }

// delete comment
@override
  Future<void> deleteComment(String postId, String commentId) async{
    try{
      //get the post document from firestore
      final postDoc =await postCollection.doc(postId).get();
      if(postDoc.exists){
        //convert json object -> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update the post document in firstore
        await postCollection.doc(postId).update({
          'comments':post.comments.map((comment) => comment.toJson()).toList(),
        });
      }else{
        throw Exception("Post not found");
      }
    }
    catch(e){
      throw Exception("Error deleting comment: $e");
    }    
  }


}

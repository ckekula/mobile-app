import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store the posts in a collection called 'posts'
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async{
    try {
      await postCollection.doc(post.id).set(post.toJson());
    }
    catch(e){
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(Post postId) async{
    await postCollection.doc(postId.id).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async{
    //TODO: implement fetchAllPosts
    try {
      //get all post most recent post at the top
      final postSnapshots = await postCollection.orderBy('timestamp', descending: true).get();

      //convert each firstore document from json -> list of posts
      final List<Post> allposts = postSnapshots.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String , dynamic>))
        .toList();

        return allposts;
    }
    catch(e){
      throw Exception("Error fetching posts: $e");
    }
  }

  @override

  Future<List<Post>> fetchPostsByUserId(String userId) async{
    // TODO: implement fetchPostsByUserId
    try{
      //fetch post snapshots with this uid
      final postSnapshots = await postCollection.where("userId", isEqualTo: userId).get();

      //convert firstore document from json -> list of posts
      final userPosts = postSnapshots.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String , dynamic>))
        .toList();
      
      return userPosts;
    }
    catch(e){
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
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/features/post/domain/entities/post.dart';
import 'package:mobile_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final firebaseFirestore = FirebaseFirestore.instance;

  //store the posts in a collection called 'posts'
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async{
    //TODO: implement createPost
    try {
      await postCollection.doc(post.id).set(post.toJson());
    }
    catch(e){
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(Post post) async{
    await postCollection.doc(post.id).delete();
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

}
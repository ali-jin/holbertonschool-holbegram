import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:uuid/uuid.dart';


class PostStorage {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<String> uploadPost(
        String caption,
        String uid,
        String username,
        String profImage,
        Uint8List image,
    ) async {
        try {
      String id = const Uuid().v1();
      final String postUrl =
          await StorageMethods().uploadImageToStorage(true, "posts", image);
      Post post = Post(
          caption: caption,
          uid: id,
          username: username,
          likes: [],
          postId: uid,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          profImage: profImage);

      await _firestore.collection("posts").doc(post.uid).set(post.toJson());
      await _firestore.collection("users").doc(uid).update({
        'posts': FieldValue.arrayUnion([id]),
      });
      return "Ok";
    } catch (error) {
      return error.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString()); 
    }
  }
   Future<String> addToFavorite({
    required String idPost,
    required String idUser,
  }) async {
    try {

      await _firestore.collection("users").doc(idUser).update({
        'saved': FieldValue.arrayUnion([idPost]),
      });
      return "OK";
    } catch (error) {
      throw error;
    }
  }
   Future<String> addToLikes({
    required String idPost,
    required String idUser,
  }) async {
    try {
      await _firestore.collection("posts").doc(idPost).update({
        'likes': FieldValue.arrayUnion([idUser]),
      });
      return "OK";
    } catch (error) {
      throw error;
    }
  }
   Future<List<DocumentSnapshot>?> getPosts(List<dynamic> postsIds) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('posts');
    if (postsIds.isNotEmpty) {
      final query = collection.where(FieldPath.documentId, whereIn: postsIds);
      final querySnapshot = await query.get();
      return querySnapshot.docs;
    } else {
      return null; 
    }
  }

}
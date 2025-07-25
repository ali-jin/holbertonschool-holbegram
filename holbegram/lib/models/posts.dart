import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

    factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      caption: json['caption'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      likes: json['likes'] ?? [],
      postId: json['postId'] ?? '',
      datePublished: DateTime.parse(json['datePublished']),
      postUrl: json['postUrl'] ?? '',
      profImage: json['profImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    
    return Post(
      caption: snapshot['caption'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'].toDate(),
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
    );
  }
}
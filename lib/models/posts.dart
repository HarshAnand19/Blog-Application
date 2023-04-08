import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String title;
  final String uid;
  final String postId;
  final String username;
  final  datePublished;
  final timePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final bookmark;

  const Post({
    required this.description,
    required this.title,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.timePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.bookmark

  });

  Map<String,dynamic> toJson() =>{
    'description':description,
    'title':title,
    'uid':uid,
    'username':username,
    'postId':postId,
    'datePublished':datePublished,
    'timePublished':timePublished,
    'profImage':profImage,
    'likes':likes,
    'postUrl':postUrl,
    'bookmark':bookmark
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return Post(
      username: snapshot['username'],
      title: snapshot['title'],
      uid: snapshot['uid'],
      datePublished: snapshot['datePublished'],
      timePublished: snapshot['timePublished'],
      profImage: snapshot['profImage'],
      description: snapshot['description'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
      postId: snapshot['postId'],
      bookmark: snapshot['bookmark']
    );
  }
}
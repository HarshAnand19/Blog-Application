import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app/models/posts.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload posts
  Future<String> uploadPost(
      String description,
      String title,
      File file,
      String uid,
      String username,
      String profImage,
      )
  async{
    String res= 'some error occured';
    try{
      String photoUrl =await  StorageMethods().uploadImageFile('postsImages', file, true);

      String postId = Uuid().v1();

      var date1=DateTime.now();
      var postDateKey =DateFormat('MMM d,yyyy');
      var postTimeKey =DateFormat('EEEE,hh:mm aaa');
      String formatDate=postDateKey.format(date1);
      String formatTime=postTimeKey.format(date1);

      Post post =Post(
          description:description,
          title: title,
          uid:uid,
          username:username,
          postId: postId,
          datePublished: formatDate,
          timePublished: formatTime,
          postUrl: photoUrl,
          profImage: profImage,
          likes: []
      );

      _firestore.collection('posts').doc(uid).collection('posts').doc(postId).set(post.toJson());

      res="success";
    }catch(e){
      res=e.toString();
    }
    return res;
  }
}
import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app/models/comments.dart';
import 'package:blog_app/models/posts.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          likes: [],
          bookmark: []
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res="success";
    }catch(e){
      res=e.toString();
    }
    return res;
  }

  //like Post
  Future<void> likePost(String postId,String uid,List likes) async{

    try {
      //if likes contains my uid dislike it,otherwise like it
      //if likes doesnt exists add our uid with all other uid

      if (likes.contains(uid)) {
        await  _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await  _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid])
        });
      }

    }catch(e){
      print(e.toString());
    }
  }

  //Comments
  Future<void> postComments(String postId,String text,String uid,String name,String profilePic,Typeu type) async{

    var date1=DateTime.now();
    var postDateKey =DateFormat('MMM d,yyyy');
    String formatDate=postDateKey.format(date1);
    try{

        String commentId =Uuid().v1();
        Comments comments =Comments(
            profilePic: profilePic,
            name: name,
            uid: uid,
            type: type,
            text: text,
            commentId: commentId,
            datePublished: formatDate
        );
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
          comments.toJson());

    }catch(e){
      print(e.toString());
    }
  }

  Future<void> likebookmark(String postId,String uid,List bookmark,BuildContext context) async{
    try {

      if (bookmark.contains(uid)) {
        await  _firestore.collection('posts').doc(postId).update({
          'bookmark': FieldValue.arrayRemove([uid]),
        }).then((value) => showSnackBar('Bookmark removed', context));
      } else {
        await  _firestore.collection('posts').doc(postId).update({
          'bookmark':FieldValue.arrayUnion([uid])
        }).then((value) => showSnackBar('Bookmark added', context));
      }

    }catch(e){
      print(e.toString());
    }
  }
}
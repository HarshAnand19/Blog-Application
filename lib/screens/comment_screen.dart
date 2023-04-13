import 'dart:io';

import 'package:blog_app/models/comments.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/resources/firestore_methods.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:blog_app/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';


class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }
bool _isuploading=false;
  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection('posts').
        doc(widget.snap['postId']).
        collection('comments').
        orderBy('datePublished',descending: true).
        snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder:(context,index){
                return  CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data(),
                );
              }
          );
        },

      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity ,
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),

                Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(left: 16,right: 8),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _commentController,
                        decoration: InputDecoration(
                            hintText: 'Enter a Comment ${user.username}',
                            border: InputBorder.none
                        ),
                      ),
                    )
                ),


                IconButton(onPressed: () async{
                  // Pick single images from gallery
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);


                  if(image !=null){
                    print('Image Path :${image.path}');
                    try{
                      final file = File(image.path!);
                      await StorageMethods().sendCommentImage(
                          file,
                          widget.snap['postId'].toString(),
                          image.path.toString(),
                          widget.snap['uid'].toString(),
                          user.username.toString(),
                          user.photoUrl.toString(),
                          Typeu.image);
                      setState(() {
                        _isuploading=false;
                      });
                    }catch(e){
                     print(e.toString());
                    }
                    }
                },
                    icon: Icon(Icons.photo,color:Theme.of(context).textTheme.bodyText1!.color,)),

                IconButton(onPressed: () async{
                  // Pick single images from camera
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);


                  if(image !=null){
                    print('Image Path :${image.path}');
                    try{
                      final file = File(image.path!);
                      await StorageMethods().sendCommentImage(
                          file,
                          widget.snap['postId'].toString(),
                          image.path.toString(),
                          widget.snap['uid'].toString(),
                          user.username.toString(),
                          user.photoUrl.toString(),
                          Typeu.image);
                      setState(() {
                        _isuploading=false;
                      });
                    }catch(e){
                      print(e.toString());
                    }
                  }
                },
                    icon: Icon(Icons.camera_alt,color:Theme.of(context).textTheme.bodyText1!.color,)),

                InkWell(
                  onTap:() async {
                    if (_commentController.text.isNotEmpty) {
                      //Posting Comments
                      await FireStoreMethods().postComments(
                          widget.snap['postId'],
                          _commentController.text,
                          user.uid,
                          user.username,
                          user.photoUrl.toString(),
                          Typeu.text
                      );
                      setState(() {
                        _commentController.text = "";
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9,horizontal: 9),
                    child: Text('Post',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}

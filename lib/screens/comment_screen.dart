import 'package:blog_app/models/user.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/resources/firestore_methods.dart';
import 'package:blog_app/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                        controller: _commentController,
                        decoration: InputDecoration(
                            hintText: 'Enter a Comment ${user.username}',
                            border: InputBorder.none
                        ),
                      ),
                    )
                ),
                InkWell(
                  onTap:() async{

                    //Posting Comments
                    await FireStoreMethods().postComments(
                        widget.snap['postId'],
                        _commentController.text,
                        user.uid,
                        user.username,
                        user.photoUrl
                    );
                    setState(() {
                      _commentController.text="";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9,horizontal: 9),
                    child: Text('Post',style: TextStyle(color: Colors.blue),),
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

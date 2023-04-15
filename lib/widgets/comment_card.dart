import 'package:blog_app/models/comments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  const CommentCard({Key? key,required this.snap, required this.postId}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
String username="";
late String _updatedComment;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updatedComment=widget.snap['text'];
}
  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
            widget.snap['profilePic']== null? NetworkImage('https://www.iprcenter.gov/image-repository/blank-profile-picture.png/@@images/image.png'):
            NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                widget.snap['type'] == 'text'?
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   //username
                   Row(
                     children: [
                       widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid?
                       StreamBuilder<DocumentSnapshot>(
                         stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                         builder: (context, snapshot) {
                           if (snapshot.hasData) {
                             Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                             username = data['username'];
                             return Text(' ${username}', style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.bodyText1!.color));
                           } else {
                             return Text('${username}', style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.bodyText1!.color));
                           }
                         },
                       ):
                       Text(widget.snap['name'], style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.bodyText1!.color)),

                       Text('  ${widget.snap['text']}', style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color))
                     ],
                   ),

                  if( widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid)
                   IconButton(
                     onPressed: () => showCommentsOptionsDialogText(context, widget.postId.toString()),
                     icon: Icon(Icons.more_vert,color: Theme.of(context).textTheme.bodyText1!.color),
                   )
                 ],
               ):

                InkWell(
                  onLongPress: () {
                    if (widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                      showCommentsOptionsDialogImage(context, widget.postId.toString());
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        imageUrl: widget.snap['text'],
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2,),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.image,size: 70,color: Colors.red,)
                    ),
                  ),
                ),


                  Padding(
                    padding:EdgeInsets.only(top: 4),
                    child: Text(
                      widget.snap['datePublished'],
                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  //Delete and Edit Dialog Option
  void showCommentsOptionsDialogText(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: [
            InkWell(
              onTap: () async {
                _firestore.collection('posts').doc(postId).collection('comments').doc(widget.snap['commentId']).delete();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text('Delete'),
              ),
            ),
            InkWell(
              onTap: () {
               _showEditDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCommentsOptionsDialogImage(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: [
            InkWell(
              onTap: () async {
                await _firestore.collection('posts').doc(postId).collection('comments').doc(widget.snap['commentId']).delete();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    String updatedComment = widget.snap['text'];
Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.edit,color: Colors.blue,),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 5.0,
          title: Text("Edit Your Comment"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  initialValue:widget.snap['text'],
                  maxLines: null,
                  onChanged: (value) => updatedComment = value,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(color: Colors.blue),
                    hintText: "Enter updated Comment",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.8,
                        color: Colors.blue,
                      ),
                    ),

                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",style: TextStyle(color: Colors.blue),),
              onPressed: () {
                _firestore.collection('posts').doc(widget.postId).collection('comments').doc(widget.snap['commentId']).update({
                  'text': updatedComment,
                }).then((value) {
                  setState(() {
                    // Rebuild the widget with the updated values
                    widget.snap['text'] = _updatedComment;
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

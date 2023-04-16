import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/screens/full_screen_image_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;


class ViewPosts extends StatefulWidget {
  late  String title;
  late  String desc;
  final String photo;
  final String id;
  final String date;
  final String time;
  final String profImage;
final String postId;

  ViewPosts({
    Key? key,
    required this.title,
    required this.desc,
    required this.photo,
    required this.id,
    required this.date,
    required this.time,
    required this.profImage,
    required this.postId,
  }) : super(key: key);

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  late String _updatedTitle;
  late String _updatedDesc;

  @override
  void initState() {
    super.initState();
    _updatedTitle = widget.title;
    _updatedDesc = widget.desc;
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

FirebaseAuth _auth =FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Tooltip(
                message: widget.title ?? '',
                child: Text(
                  widget.title ?? '',
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _sharefiles();
              },
              icon: Icon(Icons.share),
            ),

            if(widget.id == _auth.currentUser!.uid)
              IconButton(
                onPressed: () {
                  _showEditDialog(context);
                },
                icon: Icon(Icons.edit),
              ),

            if(widget.id == _auth.currentUser!.uid)
            IconButton(
              onPressed: () {
                _showDialog(context);
              },
              icon: Icon(Icons.delete),
            ),


          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>
                 FullScreenImagePreview(heroTag:'imageTag' , imageUrl: widget.photo)));
              },
              child: Hero(
                tag: 'imageTag',
                child: Image.network(
                  width: double.infinity,
                  widget.photo,
                  height: MediaQuery.of(context).size.height*.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profImage),
                        radius: 16,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.date),
                          Text(widget.time),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(widget.desc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(context){
    AwesomeDialog(

        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Delete Post',
        desc: 'Are you sure you want to delete this post',
        btnCancelOnPress: () {
        },
        btnOkOnPress: () {
          _firestore.collection('posts').doc(widget.postId).delete();
          Navigator.pop(context);
        }
    )..show();
  }

  void _sharefiles() async{
    String doc ="Hey! Checkout this blog, \n Title - ${widget.title}\n Description - ${widget.desc} ";
    http.Response response = await http.get(Uri.parse(widget.photo));
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final file = File('$path/image.png');
    file.writeAsBytes(response.bodyBytes);
    Share.shareFiles(['$path/image.png'],text: doc,);

  }

  void _showEditDialog(BuildContext context) {
    String updatedTitle = widget.title;
    String updatedDesc = widget.desc;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.edit,color: Colors.blue,),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 5.0,
          title: Text("Edit Your  Post"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue:widget.title,
                  maxLines: null,
                  onChanged: (value) => updatedTitle = value,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.blue),
                    hintText: "Enter updated Title",
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

                SizedBox(height: MediaQuery.of(context).size.height*.02,),

                TextFormField(
                  initialValue: widget.desc,
                  maxLines: null,
                  onChanged: (value) => updatedDesc = value,
                  decoration: InputDecoration(
                      labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.blue),
                      hintText: "Enter updated Description",
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
                )
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
              child: Text("Save",style: TextStyle(color: Colors.blue),),
              onPressed: () async{
               await _firestore.collection('posts').doc(widget.postId).update({
                  'title': updatedTitle,
                  'description': updatedDesc,
                }).then((value) {
                  setState(() {
                    // Rebuild the widget with the updated values
                    widget.title = updatedTitle;
                    widget.desc = updatedDesc;
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

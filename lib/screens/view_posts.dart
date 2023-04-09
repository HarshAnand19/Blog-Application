import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
class ViewPosts extends StatefulWidget {
  final String title;
   final String desc;
  final String photo;
 final String id;
 final String date;
 final String time;
 final String profImage;
   ViewPosts({Key? key,
     required this.title,
     required this.desc,
     required this.photo,
     required this.id,
     required this.date,
     required this.time,
     required this.profImage,
    }) : super(key: key);

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ''),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(

          child: Column(

            children: [

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      placeholder: 'assets/images/firebase.png',
                      image: widget.photo ?? ''
                  ),
                ),
              ),



              SizedBox(height:MediaQuery.of(context).size.height*.05),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(widget.title ?? '',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

                    Row(
                      children: [
                  IconButton(
                      onPressed: (){
                        // _sharefiles();
                    }, icon:Icon(Icons.share,color: Colors.blue,)),

                        IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: (){
                            // _showDialog(context);
                          },
                        ),
                      ],
                    )
                    ],
                    ),
SizedBox(height: 8,),

                    Align(
                        // alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(widget.profImage),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.date ?? '',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(widget.time??'',style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: MediaQuery.of(context).size.height*.01,),
                                Text(widget.desc??'',style: TextStyle(fontSize: 18),),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );


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
            // postRef.child('Post List').child(widget.id).remove();
            // final ref =storage.ref().child('PostImages/').child(widget.id).delete();
            // Navigator.pop(context);
          }
    )..show();
  }
}

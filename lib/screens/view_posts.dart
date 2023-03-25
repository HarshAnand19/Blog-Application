import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:awesome_dialog/awesome_dialog.dart';

class ViewPosts extends StatefulWidget {
  final String title;
  final String desc;
 final String photo;
 final String id;
 final String date;
 final String time;
   ViewPosts({Key? key,required this.title, required this.desc, required this.photo, required this.id, required this.date, required this.time}) : super(key: key);

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  int date = DateTime.now().millisecondsSinceEpoch;
  final postRef = FirebaseDatabase.instance.reference().child('Posts');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(

          child: Column(

            children: [

              Center(
                child: ClipRRect(
                  borderRadius:BorderRadius.circular(0.0),
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 1 ,
                      height: MediaQuery.of(context).size.height * .4,
                      placeholder: 'assets/images/firebase.png',
                      image:widget.photo
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
                      Text(widget.title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

                    IconButton(
                      icon: Icon(Icons.delete,color: Colors.red,),
                      onPressed: (){
                        // showDialog(context: context,builder: (context){
                        //   return Container(
                        //     child: AlertDialog(
                        //       title: Text('Do you want to delete this post?'),
                        //       actions: [
                        //         TextButton(onPressed: (){
                        //            Navigator.pop(context);
                        //            postRef.child('Post List').child(widget.id).remove();
                        //            Navigator.pop(context);
                        //         }, child:Text('YES')),
                        //         TextButton(onPressed: (){
                        //           Navigator.pop(context);
                        //         }, child:Text('CANCEL')),
                        //       ],
                        //     ),
                        //   );
                        // });
                        _showDialog(context);
                      },
                    )
                    ],
                    ),
SizedBox(height: 8,),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.date,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(widget.time,style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: MediaQuery.of(context).size.height*.01,),
                            Text(widget.desc,style: TextStyle(fontSize: 18),),
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
            postRef.child('Post List').child(widget.id).remove();
            final ref =storage.ref().child('PostImages/').child(widget.id).delete();
            Navigator.pop(context);
          }
    )..show();
  }
}

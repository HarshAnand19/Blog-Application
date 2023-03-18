import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ViewPosts extends StatefulWidget {
  final String title;
  final String desc;
 final String photo;
 final String id;
   ViewPosts({Key? key,required this.title, required this.desc, required this.photo, required this.id}) : super(key: key);

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  int date = DateTime.now().millisecondsSinceEpoch;
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(widget.title,style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),

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

                  SizedBox(height: 20,),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.desc,style: TextStyle(fontSize: 18,color: Colors.black87),)),
                ],
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
      Navigator.pop(context);
    },
    )..show();
  }
}

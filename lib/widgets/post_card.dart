import 'package:blog_app/models/user.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/resources/firestore_methods.dart';
import 'package:blog_app/screens/comment_screen.dart';
import 'package:blog_app/screens/view_profile.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLength=0;
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }
  void getComments() async{
 try{
   QuerySnapshot snap=await _firestore.collection('posts').doc(widget.snap['postId']).collection('comments').get();
   commentLength=snap.docs.length;
 }catch(e){
   showSnackBar(e.toString(), context);
 }
 setState(() {

 });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){

        },
        child: Card(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2.5,
          borderOnForeground: true,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(widget.snap['profImage']),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.snap['datePublished'],style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 30,),
                            Text(widget.snap['timePublished'],style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Text(widget.snap['username'])
                      ],
                    ),
                  ],
                ),
              ),


              //fetching the details from server(post image + post title + post desc)
              ClipRRect(
                borderRadius:BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * .25,
                    placeholder: 'assets/images/firebase.png',
                    image:widget.snap['postUrl']
                ),
              ),

              Row(
                children: [

                  //Like Button
                  IconButton(onPressed: () async{
                    await FireStoreMethods().likePost(widget.snap['postId'], user.uid,widget.snap['likes']);

                  },
                      icon:
                      //check whether to like or not
                      widget.snap['likes'].contains(user.uid)?
                      Icon(Icons.favorite,color: Colors.red,):
                      Icon(Icons.favorite_border_outlined,color: Colors.red,)
                  ),

                  
                  //Comment Button
                  IconButton(onPressed:() => Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>CommentScreen(snap:  widget.snap))),
                      icon:Icon(Icons.comment_outlined, color: Theme.of(context).textTheme.bodyText1!.color,)
                  ),

                  Expanded(
                      child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border,color: Colors.green,)),
                  )
                  )
                ],
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    //No. of Likes
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight:FontWeight.bold),
                      child: Text(
                          "${widget.snap['likes'].length} likes"
                      ),
                    ),

                    Container(
                      width:double.infinity,
                      padding: EdgeInsets.only(top:8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.snap['title'],style: TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                          Text(widget.snap['description'],style: TextStyle(fontSize:14)),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(snap: widget.snap,))),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('View all ${commentLength} comments',style: TextStyle(fontWeight: FontWeight.w400),),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

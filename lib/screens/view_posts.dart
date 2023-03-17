import 'package:flutter/material.dart';


class ViewPosts extends StatefulWidget {
  final String title;
  final String desc;
 final String photo;
  const ViewPosts({Key? key,required this.title, required this.desc, required this.photo}) : super(key: key);

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
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
                  Text(widget.title,style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),

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
}

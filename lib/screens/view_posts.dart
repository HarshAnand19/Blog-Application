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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * .25,
                  placeholder: 'assets/images/firebase.png',
                  image:widget.photo
            ),
            ),
            Text(widget.title,style: TextStyle(fontSize: 21,color: Colors.black),),

            SizedBox(height: 20,),

            Text(widget.desc,style: TextStyle(fontSize: 21,color: Colors.blue),),
          ],
        ),
      ),
    );
  }
}

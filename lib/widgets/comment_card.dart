import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(text: widget.snap['name'],
                            style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.bodyText1!.color)),
                        TextSpan(text: '  ${widget.snap['text']}',
                            style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
                      ]
                  )
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

          //Like Button
          // Column(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.all(8),
          //       child: Icon(Icons.favorite_outline,size: 16,color: Colors.red,),
          //     ),
          //
          //     Text("10")
          //   ],
          // )
        ],
      ),
    );
  }
}

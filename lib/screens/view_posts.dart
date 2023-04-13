import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import'package:http/http.dart' as http;

class ViewPosts extends StatelessWidget {
  final String title;
  final String desc;
  final String photo;
  final String id;
  final String date;
  final String time;
  final String profImage;
final String postId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(title ?? ''),
            ),
            IconButton(
              onPressed: () {
            _sharefiles();
              },
              icon: Icon(Icons.share),
            ),
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
            Image.network(
              width: double.infinity,
              photo,
              height: MediaQuery.of(context).size.height*.4,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profImage),
                        radius: 16,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date),
                          Text(time),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(desc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sharefiles() async{
    String doc ="Hey! Checkout this blog, \n Title - ${title}\n Description - ${desc} ";
    http.Response response = await http.get(Uri.parse(photo));
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
          _firestore.collection('posts').doc(postId).delete();
          Navigator.pop(context);
        }
    )..show();
  }
}

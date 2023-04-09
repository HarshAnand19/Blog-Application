import 'package:blog_app/models/user.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookmarks'),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _firestore
                .collection('posts')
                .where('bookmark',arrayContains: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Posts: ${snapshot.data?.docs.length ?? 0}',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('posts').orderBy('datePublished', descending: true).where('bookmark',arrayContains: user.uid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      return PostCard(
                        snap: snapshot.data?.docs[index].data() ?? {},
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}


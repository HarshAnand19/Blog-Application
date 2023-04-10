import 'package:blog_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';

class SearchBlogs extends StatefulWidget {
  const SearchBlogs({Key? key}) : super(key: key);

  @override
  State<SearchBlogs> createState() => _SearchBlogsState();
}

class _SearchBlogsState extends State<SearchBlogs> {
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  TextEditingController searchController=TextEditingController();
  String search="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //search field
            TextFormField(
              controller:searchController,
              decoration: InputDecoration(
                focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    borderSide: BorderSide(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!)
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0)
                ),
                hintText: 'Search a blog title',
                prefixIcon: Icon(Icons.search,color:Theme.of(context).floatingActionButtonTheme.backgroundColor! ,),
              ),
              onChanged: (String value){
                setState(() {
                  search=value;
                });
              },
            ),

            Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('posts')
                      .orderBy('datePublished', descending: true)
                      .where('title', isEqualTo: search)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context,index) {
                          return PostCard(
                            snap: snapshot.data?.docs[index].data() ?? {},
                          );
                        }
                    );
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}


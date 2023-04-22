import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/screens/add_posts.dart';
import 'package:blog_app/screens/bookmark_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/my_blogs.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/screens/register_screen.dart';
import 'package:blog_app/screens/search_blogs.dart';
import 'package:blog_app/screens/view_posts.dart';
import 'package:blog_app/screens/view_profile.dart';
import 'package:blog_app/widgets/change_theme_button.dart';
import 'package:blog_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Get reference of firebase database
  final dbRef=FirebaseDatabase.instance.reference().child('Posts');
  FirebaseFirestore _firestore= FirebaseFirestore.instance;

  FirebaseAuth auth=FirebaseAuth.instance;

  TextEditingController searchController=TextEditingController();
  String search="";
  String username="";
  String photoUrl="";
 String email="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshUserData();
  getUserDetail();
  }
  refreshUserData() async {
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
    setState(() {
      username = _userProvider.getUser.username;
      photoUrl = _userProvider.getUser.photoUrl;
      email=_userProvider.getUser.email;
    });
  }

  void getUserDetail() async{
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  setState(() {
    username=(snap.data() as Map<String,dynamic>)['username'];
    photoUrl=(snap.data() as Map<String,dynamic>)['photoUrl'];
    email=(snap.data() as Map<String,dynamic>)['email'];

  });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: ()async{
       SystemNavigator.pop();
       return true;
     },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                username = data['username'];
                return Text('Welcome back $username', style: TextStyle(fontSize: 16));
              } else {
                return Text('Welcome back $username', style: TextStyle(fontSize: 16));
              }
            },
          ),

          actions: [
            //dark theme
            ChangeThemeButtonWidget(),

          ],
        ),


        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //search field
         //      TextFormField(
         //        controller:searchController,
         //        decoration: InputDecoration(
         //          focusedBorder:OutlineInputBorder(
         //              borderRadius: BorderRadius.circular(35.0),
         //             borderSide: BorderSide(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!)
         //          ),
         //            border: OutlineInputBorder(
         //              borderRadius: BorderRadius.circular(35.0)
         //            ),
         //            hintText: 'Search a blog title',
         //            prefixIcon: Icon(Icons.search,color:Theme.of(context).floatingActionButtonTheme.backgroundColor! ,),
         //        ),
         //        onChanged: (String value){
         // setState(() {
         //   search=value;
         // });
         //        },
         //      ),

              Expanded(

                  child:StreamBuilder(
                    stream: _firestore.collection('posts').orderBy('datePublished',descending: true).snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                     if(snapshot.connectionState == ConnectionState.waiting){
                       return Center(child: CircularProgressIndicator(),);
                     }
                     return ListView.builder(
                         itemCount: snapshot.data!.docs.length,
                         itemBuilder: (context,index) {
                           return PostCard(
                             snap: snapshot.data!.docs[index].data(),
                           );
                         }
                     );
                    },
                  )

              )
            ],
          ),
        ),



        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>AddPostScreen()));
          },
          child: Icon(Icons.add,color: Colors.white,),
        ),

        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height*.35,
                child: UserAccountsDrawerHeader(
                  currentAccountPictureSize: Size.fromRadius(56.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                  ),
                  accountName: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                        username = data['username'];
                        return Text(' ${username}', style: TextStyle(fontSize: 20,color:Theme.of(context).scaffoldBackgroundColor));
                      } else {
                        return Text('${username}', style: TextStyle(fontSize: 20,color:Theme.of(context).scaffoldBackgroundColor));
                      }
                    },
                  ),
                  accountEmail: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                        email = data['email'];
                        return Text(' ${email}', style: TextStyle(fontSize: 14,color:Theme.of(context).scaffoldBackgroundColor));
                      } else {
                        return Text('${email}', style: TextStyle(fontSize: 14,color:Theme.of(context).scaffoldBackgroundColor));
                      }
                    },
                  ),
                  currentAccountPicture: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                        photoUrl = data['photoUrl'];
                        return  CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                        );
                      } else {
                        return  CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                        );
                      }
                    },
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                      Navigator.pop(context);

                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>ViewProfile(uid:FirebaseAuth.instance.currentUser!.uid,)));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('Bookmarked Posts'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookmarkScreen()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('My Posts'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBlogs()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Search'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchBlogs()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {
                        _showDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  _showDialog(context){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Logout',
        desc: 'Do you want to logout?',
        btnCancelOnPress: () {
        },
        btnOkOnPress: () async{
          await  auth.signOut().then((value){
             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
           });
        }
    ).show();
  }
}

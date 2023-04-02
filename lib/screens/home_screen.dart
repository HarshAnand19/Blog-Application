import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/screens/add_posts.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/screens/register_screen.dart';
import 'package:blog_app/screens/view_posts.dart';
import 'package:blog_app/screens/view_profile.dart';
import 'package:blog_app/widgets/change_theme_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Get reference of firebase database
  final dbRef=FirebaseDatabase.instance.reference().child('Posts');

  FirebaseAuth auth=FirebaseAuth.instance;

  TextEditingController searchController=TextEditingController();
  String search="";
  String username="";
  String photoUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getUserDetail();
  }

  void getUserDetail() async{
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  setState(() {
    username=(snap.data() as Map<String,dynamic>)['username'];
    photoUrl=(snap.data() as Map<String,dynamic>)['photoUrl'];

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
          title: Text('Welcome back ${username}',style: TextStyle(fontSize: 16),),
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

                //using FirebaseAnimatedList to show items in a list
                  child:FirebaseAnimatedList(
                    query: dbRef.child('Post List'),
                    itemBuilder: (BuildContext context,
                   DataSnapshot snapshot, Animation<double> animation, int index) {

                      String tempTitle=snapshot.child('pTitle').value.toString();

                      //passing data to viewposts screen
                      String title1=snapshot.child('pTitle').value.toString();
                      String desc1=snapshot.child('pDesc').value.toString();
                      String pic=snapshot.child('pImage').value.toString();
                        String id1 =snapshot.child('pId').value.toString();
                        String date1=snapshot.child('uploadDate').value.toString();
                          String time1=snapshot.child('uploadTime').value.toString();


                      if(searchController.text.isEmpty){
                        return InkWell(
                          onTap: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>
                         ViewPosts(title: title1,desc:desc1,photo: pic,id: id1,date: date1,time: time1,)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.child('uploadDate').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(snapshot.child('uploadTime').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        Text(snapshot.child('uEmail').value.toString())
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
                                        image:snapshot.child('pImage').value.toString()),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.child('pTitle').value.toString(),
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.child('pDesc').value.toString(),
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );

                      }else if(tempTitle.toLowerCase().contains(searchController.text.toLowerCase().toString())){

                        return InkWell(
                          onTap: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>
                                    ViewPosts(title: title1,desc:desc1,photo: pic,id: id1,date: date1,time: time1,)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.child('uploadDate').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(snapshot.child('uploadTime').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        Text(snapshot.child('uEmail').value.toString())
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
                                        image:snapshot.child('pImage').value.toString()),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.child('pTitle').value.toString(),
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.child('pDesc').value.toString(),
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      }else{
                        return Container();
                      }

                    },
                  ) ,
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
                  accountName: Center(child: Text(username,style: TextStyle(fontSize: 20,color:Theme.of(context).scaffoldBackgroundColor ),)),
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
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
                        // Handle drawer item tap
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

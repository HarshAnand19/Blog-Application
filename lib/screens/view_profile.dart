import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/main.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
 var userData ={};
 bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getData();
  }

  FirebaseAuth auth=FirebaseAuth.instance;

  //fetch user details from firebase firestore
 getData() async{
   setState(() {
     isLoading=true;
   });

   try{
     var userSnap =await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
   userData=userSnap.data()!;
   setState(() {

   });

   }catch(e){
    showSnackBar(e.toString(), context);
   }
   setState(() {
     isLoading=false;
   });
 }
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;

    return isLoading ? Center(child: CircularProgressIndicator(),) :
    Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title:Text(userData['username']),
        centerTitle: true,
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: mq.width*.05),
          child: Column(
            children: [
              
              SizedBox(width: mq.width,height: mq.height*.03,),

              Stack(
                children: [
                 ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height*.1),
                  child: CachedNetworkImage(
                    width: mq.height *.2,
                    height: mq.height *.2,
                    fit: BoxFit.fill,
                    imageUrl: userData['photoUrl'],
                    errorWidget: (context,url,error) => CircleAvatar(child: Icon(CupertinoIcons.person),)
                  )
                ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      elevation: 1,
                      color: Colors.white,
                      onPressed: (){},
                      shape: CircleBorder(),
                      child: Icon(Icons.edit,color: Colors.blue,),
                    ),
                  ),
              ],
              ),


              SizedBox(height: mq.height*.03,),

              Text(userData['email'],style:TextStyle(fontSize: 16)),

              SizedBox(height: mq.height*.03,),

              TextFormField(
                initialValue: userData['username'],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter a username',
                  label: Text('Username')
                ),
              ),

              SizedBox(height: mq.height*.02,),

              TextFormField(
                initialValue: userData['username'],
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Enter a username',
                    label: Text('About')
                ),
              ),

              SizedBox(height: mq.height*.05,),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: StadiumBorder(),
                  minimumSize: Size(mq.width*.5,mq.height*.06),
                ),
                  onPressed:(){} ,
                  icon: Icon(Icons.edit,size: 28,),
                label: Text('UPDATE ',style: TextStyle(fontSize: 16),),
              )

            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
            onPressed:(){
              _showDialog(context);
            } ,
            icon: Icon(Icons.logout,color: Colors.white,),
          label: Text('Logout',style: TextStyle(color: Colors.white),),
        )
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

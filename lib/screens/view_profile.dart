import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/main.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
 var userData ={};
 bool isLoading=false;
 final _formkey=GlobalKey<FormState>();
 late TextEditingController _usernameController;
 late TextEditingController _bioController;
 String username="";
String? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController(text: '');
    _bioController = TextEditingController(text: '');
    getData();


  }

  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //fetch user details from firebase firestore
 getData() async{
   setState(() {
     isLoading=true;
   });

   try{
     var userSnap =await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
   userData=userSnap.data()!;
     _usernameController.text = userData['username'];
     _bioController.text = userData['bio'];
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              username = data['username'];
              return Text(' ${username}', style: TextStyle(fontSize: 20,));
            } else {
              return Text('${username}', style: TextStyle(fontSize: 20,));
            }
          },
        ),
        centerTitle: true,
      ),

      body:SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: mq.width*.05),
            child: Column(
              children: [

                SizedBox(width: mq.width,height: mq.height*.03,),


                //Profile picture
                Stack(
                  children: [

                     _image!=null?
                ClipRRect(
                borderRadius: BorderRadius.circular(mq.height*.1),
                 child: Image.file(
                   File(_image!),
                    width: mq.height*.2,
                   height: mq.height*.2,
                      fit:BoxFit.cover,

            ),
          ):
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
                        onPressed:_showBottomSheet,
                        shape: CircleBorder(),
                        child: Icon(Icons.edit,color: Colors.blue,),
                      ),
                    ),
                ],
                ),


                SizedBox(height: mq.height*.03,),

                Text(userData['email'],style:TextStyle(fontSize: 16)),

                SizedBox(height: mq.height*.03,),

                //Username Field
                TextFormField(
                  controller: _usernameController,
                  validator: (val) =>
              val!=null && val.isNotEmpty ? null :"Required Field",
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

                //Bio Field
                TextFormField(
                controller: _bioController,
                  validator: (val) =>
                  val!=null && val.isNotEmpty ? null :"Required Field",
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

                //Update Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width*.5,mq.height*.06),
                  ),
                    onPressed:() async{
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        isLoading=true;
                      });
                      try{
                        await _firestore.collection('users').doc(widget.uid).update({
                      'username':_usernameController.text,
                      'bio':_bioController.text
                        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( 'Profile Updated Successfully'))));
                        setState(() {
                          isLoading=false;
                        });
                      }catch(e){
                        print(e.toString());
                        setState(() {
                          isLoading=false;
                        });
                      }
                    }
                    } ,
                    icon: Icon(Icons.edit,size: 28,),
                  label: Text('UPDATE ',style: TextStyle(fontSize: 16),),
                )

              ],
            ),
          ),
        ),
      ),

      //Logout Button
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

  //for selecting images from camera and gallery in a bottom sheet and updating profile picture
 void _showBottomSheet(){
   showModalBottomSheet(context: context,
       shape:RoundedRectangleBorder(borderRadius: BorderRadius.only
         (topLeft:Radius.circular(20),topRight: Radius.circular(20))
       ), builder: (_){

         return ListView(
           padding: EdgeInsets.only(top:mq.height*.03,bottom: mq.height*.05),
           shrinkWrap: true,
           children: [
             //pick profile picture label
             Text("Pick a profile Picture",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
               textAlign: TextAlign.center,
             ),

             SizedBox(height: mq.height*.02,),

             //buttons for picking images
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [

                 //pick images from gallery
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         shape: CircleBorder(),
                         fixedSize: Size(mq.width*.3,mq.height*.15)
                     ),
                     onPressed: () async {
                       // Pick an image
                       final ImagePicker picker = ImagePicker();
                       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                       if(image!=null){

                         //setting image path
                         setState(() {
                           _image=image.path;
                         });

                         StorageMethods().updateProfilePicture(File(_image!),context);

                         //for hiding bottom sheet
                         Navigator.pop(context);
                       }

                     },
                     child:Image.asset('assets/images/add_image.png')
                 ),

                 //capture an image from camera
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         shape: CircleBorder(),
                         fixedSize: Size(mq.width*.3,mq.height*.15)
                     ),
                     onPressed: () async {
                       // Pick an image
                       final ImagePicker picker = ImagePicker();
                       final XFile? image = await picker.pickImage(source: ImageSource.camera);
                       if(image!=null){
                         //setting image path
                         setState(() {
                           _image=image.path;
                         });
                         StorageMethods().updateProfilePicture(File(_image!),context);

                         //for hiding bottom sheet
                         Navigator.pop(context);
                       }
                     },
                     child:Image.asset('assets/images/camera.png')
                 ),


               ],
             )
           ],

         );
       });
 }
}

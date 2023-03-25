import 'dart:io';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool showSpinner=false;

  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
final FirebaseAuth _auth =FirebaseAuth.instance;

 File? _image;
 final picker=ImagePicker();

 TextEditingController titleController =TextEditingController();
 TextEditingController descController =TextEditingController();

 //dialog pops up when we are trying to select an image
 void dialog(context){
   showDialog(context: context, builder: (BuildContext context){
   return AlertDialog(
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10)
     ),
     content: Container(
       height: 120,
       child: Column(
         children: [

           //For Camera
           InkWell(
             onTap: (){
               getImageCamera();
               Navigator.pop(context);
             },
             child: ListTile(
               leading: Icon(Icons.camera),
               title: Text('Camera'),
             ),
           ),

           //For Gallery
           InkWell(
             onTap: (){
               getImageGallery();
               Navigator.pop(context);
             },
             child: ListTile(
               leading: Icon(Icons.photo_library),
               title: Text('Gallery'),
             ),
           ),
         ],
       ),
     ),
   );
   }
   );
 }

 //Getting images from Gallery
 Future getImageGallery() async{
   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
   setState(() {
     if(pickedFile!=null){
       _image=File(pickedFile.path);
     }else{
    toastMessages('No image selected',false);
     }
   });
 }

 //Getting images from Camera
 Future getImageCamera() async{
   final pickedFile = await picker.pickImage(source: ImageSource.camera);
   setState(() {
     if(pickedFile!=null){
       _image=File(pickedFile.path);
     }else{
       toastMessages('No image selected',false);
     }
   });
 }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Your Blogs'),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
             children: [

               //picking images
               InkWell(
                 onTap: (){
                   dialog(context);
                 },
                 child: Center(
                   child: Container(
                     height: MediaQuery.of(context).size.height*.2,
                     width: MediaQuery.of(context).size.width*1,
                     child: _image!=null ? ClipRect(
                       child: Image.file(
                         _image!.absolute,
                         width: 150,height: 150,
                         fit: BoxFit.contain),

                     ):

                         //if image is not present
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.grey.shade200,
                         borderRadius: BorderRadius.circular(10)),
                       width: 100,
                       height: 100,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.camera_alt_sharp,
                             color: Colors.blue,
                             size: 34,
                           ),
SizedBox(height: 12,),
                           Text("Pick an image",style: TextStyle(color: Colors.black),)
                         ],
                       ),
                     )
                   ),
                 ),
               ),
               SizedBox(height: 30,),

            //for entering title & Description of blogs
               Form(
                child:Column(

                  //title
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!)
                        ),
                        labelText: 'Title',
                        hintText:'Enter Post Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!,fontWeight: FontWeight.normal),
                      ),
                    ),

                    SizedBox(height: 25,),

                    //Description
                    TextFormField(
                      controller: descController,
                      keyboardType:TextInputType.multiline,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!)
                        ),
                        labelText: 'Description',
                        hintText:'Enter  your Blog Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(color: Theme.of(context).floatingActionButtonTheme.backgroundColor!,fontWeight: FontWeight.normal),
                      ),
                    ),


                  ],
                )
               ),

               SizedBox(height: 30,),

               ElevatedButton(

                 style: ElevatedButton.styleFrom(
                   shape: StadiumBorder(),
                     minimumSize: Size.fromHeight(40),
                   backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor
                 ),
                   child: Text('Upload',
                     style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                        onPressed: ()async{
                          setState(() {
                            showSpinner=true;
                          });

                          try{

                            final User? user=_auth.currentUser;
                            //uploading post to firebase storage
                            int date = DateTime.now().millisecondsSinceEpoch;

                            //uploading image to firebase storage
                            final ref =storage.ref().child('PostImages/$date');
                            UploadTask uploadTask=ref.putFile(_image!.absolute);
                            await Future.value(uploadTask);

                            // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
                            // UploadTask uploadTask =ref.putFile(_image!.absolute);
                            // await Future.value(uploadTask);
                            var newUrl =await ref.getDownloadURL();

                            var date1=DateTime.now();
                            var postDateKey =DateFormat('MMM d,yyyy');
                            var postTimeKey =DateFormat('EEEE,hh:mm aaa');
                            String formatDate=postDateKey.format(date1);
                            String formatTime=postTimeKey.format(date1);
                            //uploading post to firebase database

                            postRef.child('Post List').child(date.toString()).set({

                              'pId':date.toString(),
                              'pImage':newUrl.toString(),
                              'pTime':date.toString(),
                              'pTitle':titleController.text.toString(),
                              'pDesc':descController.text.toString(),
                              'uEmail':user?.email.toString(),
                              'uid':user?.uid.toString(),
                              'uploadDate':formatDate.toString(),
                              'uploadTime':formatTime.toString()

                            }).then((value) {
                              toastMessages('Post  Uploaded Successfully!',true);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(name: user!.displayName.toString())));
                              setState(() {
                                showSpinner=false;
                              });
                            }).onError((error, stackTrace){
                              toastMessages(error.toString(), false);
                              setState(() {
                                showSpinner=false;
                              });
                            });

                          }catch(e){
                            setState(() {
                              showSpinner=false;
                            });
                            toastMessages(e.toString(),false);
                          }

                        },

               )

             ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessages(String message,bool isPositive){
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: isPositive?Toast.LENGTH_LONG:Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: isPositive? Colors.deepOrange:Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

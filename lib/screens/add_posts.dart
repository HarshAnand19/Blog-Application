import 'dart:io';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/resources/firestore_methods.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';



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
    final UserModel userDetail =Provider.of<UserProvider>(context).getUser;


    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Your Query'),
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
                      validator: (value){
                        return value!.isEmpty?'enter title':null;
                      },
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
                      validator: (value){
                        return value!.isEmpty?'enter description':null;
                      },
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
                        onPressed: ()=>createPosts(userDetail.uid, userDetail.username, userDetail.photoUrl)
               ),

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
        backgroundColor: isPositive? Colors.blue:Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }



void createPosts(
    String uid,
    String username,
    String profImage,
    )
  async{
   setState(() {
     showSpinner=true;
   });
   try{
     String res =await FireStoreMethods().uploadPost(
         descController.text,
         titleController.text,
         _image!,
         uid,
         username,
         profImage
     );

     if(res == "success"){
       setState(() {
         showSpinner=false;
       });
       toastMessages("Post Uploaded Successfully", true);
       Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(name:username)));
     }else{
       toastMessages(res, false);
       setState(() {
         showSpinner=false;
       });
       showSnackBar(res, context);
     }
   }catch(e){
     setState(() {
       showSpinner=false;
     });
showSnackBar(e.toString(), context);
   }
  }
}

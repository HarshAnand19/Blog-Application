import 'dart:typed_data';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/main.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool showSpinner = false;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController usernameController=TextEditingController();
  TextEditingController bioController=TextEditingController();
    String email="",password="",username="",bio="";

  Uint8List? _image;

  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
   final _formkey=GlobalKey<FormState>();

  bool showPassword=false;

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Create a new Account'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

       Padding(
             padding: const EdgeInsets.symmetric(vertical: 30),
             child: Form(
               key: _formkey,
                 child: Column(
               children: [

                 //circle avatar to show to selected file
                 Stack(
                   children:[
                     _image!=null?
                     CircleAvatar(
                         radius: 64,
                         backgroundImage:MemoryImage(_image!)
                     ):
                     CircleAvatar(
                         radius: 64,
                         backgroundImage:NetworkImage(
                             'https://www.iprcenter.gov/image-repository/blank-profile-picture.png/@@images/image.png'
                         )
                     ),
                     Positioned(
                         bottom: -10,
                         left: 80,
                         child: IconButton(
                           onPressed:_showBottomSheet
                           ,icon: Icon(Icons.add_a_photo,color: Colors.blueAccent.shade200,),)
                     )
                   ],
                 ),

                 SizedBox(height: MediaQuery.of(context).size.height*.02,),
                 //username field
                 TextFormField(
                   controller:usernameController,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Enter your Username',
                       labelText: 'Username',
                       prefixIcon: Icon(Icons.person)
                   ),
                   onChanged: (String value){
                     username=value;

                   },
                   validator: (value){
                     return value!.isEmpty?'enter username':null;
                   },
                 ),
                 SizedBox(height: MediaQuery.of(context).size.height*.03,),

                 //email field
                 TextFormField(
                   controller:emailController,
                   keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     hintText: 'Email',
                       labelText: 'Email',
                       prefixIcon: Icon(Icons.email)
                   ),
                   onChanged: (String value){
                     email=value;

                   },
                 validator: (value){
                     return value!.isEmpty?'enter email':null;
                 },
                 ),
                 SizedBox(height: MediaQuery.of(context).size.height*.03,),


                 //password field
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 5),
                   child: TextFormField(
                     controller:passwordController,
                     obscureText: showPassword?false:true,
                     keyboardType: TextInputType.emailAddress,
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                         labelText: 'Password',
                         hintText: 'Password',
                         prefixIcon: Icon(Icons.lock),

                         suffixIcon:IconButton(
                           onPressed: (){
                             setState(() {
                               showPassword=!showPassword;
                             });
                           },
                           icon: showPassword? FaIcon(FontAwesomeIcons.eyeSlash,size: 16,):Icon(Icons.remove_red_eye),

                         )
                     ),
                     onChanged: (String value){
                       password=value;
                     },
                     validator: (value){
                       return value!.isEmpty?'enter password':null;
                     },
                   ),
                 ),
                 SizedBox(height: MediaQuery.of(context).size.height*.03,),


                 //bio field
                 TextFormField(
                   controller:bioController,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Enter your Bio',
                       labelText: 'Bio',
                       prefixIcon: Icon(Icons.edit)
                   ),
                   onChanged: (String value){
                     bio=value;
                   },
                   validator: (value){
                     return value!.isEmpty?'enter bio':null;
                   },
                 ),

                 SizedBox(height: 18,),

                 RoundButton(title: 'Register',
                     onPress: () async {
                   if(_formkey.currentState!.validate()){

                     setState(() {
                       showSpinner=true;
                     });
                     try{
                     final userCred=await _auth.createUserWithEmailAndPassword
                       (email: email.toString().trim(), password: password.toString().trim());

                     //for storing profile pic in firebase storage
                     String photoUrl=await StorageMethods().uploadImage('profilePic', _image!,false);

                     UserModel user=UserModel(
                       username:usernameController.text,
                         uid:userCred.user!.uid,
                         email:emailController.text,
                         bio:bioController.text,
                         photoUrl:photoUrl,
                     );

                      await _firestore.collection('users').doc(userCred.user!.uid).set(user.toJson());

                     if(userCred!=null){
                       print('Success');
                       toastMessages('User registered Successfully!', true);
                       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(name: userCred.user!.displayName.toString(),)));

                       setState(() {
                         showSpinner=false;
                       });
                     }

                     }catch(e){
                       print(e.toString());
                       toastMessages(e.toString(),false);
                       setState(() {
                         passwordController.text="";
                         showSpinner=false;
                       });
                     }
                   }
                 }),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text("Already have an Account?"),
                     TextButton(
                         onPressed: (){
                           Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                         }, child: Text("Sign In"))
                   ],
                 )
               ],
             )
             ),
       )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage(ImageSource source) async{
    Uint8List im =await pickImage(source);
    setState(() {
      _image=im;
    });

  }

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
                      onPressed: (){
                        selectImage(ImageSource.gallery);

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
                      onPressed:(){
                        selectImage(ImageSource.camera);

          },
                      child:Image.asset('assets/images/camera.png')

                  ),

                ],
              )
            ],

          );
        }
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

import 'dart:typed_data';

import 'package:blog_app/components/round_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
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
Text("REGISTER",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),

//email field
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
                           onPressed:selectImage
                           ,icon: Icon(Icons.add_a_photo,color: Colors.blueAccent.shade100,),)
                     )
                   ],
                 ),

                 //email field
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

                 SizedBox(height: 18,),
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


                 //password field
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 25),
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

                     //for registering users
                     await _firestore.collection('users').doc(userCred.user!.uid).set({
                       'username':usernameController.text,
                       'uid':userCred.user!.uid,
                       'email':emailController.text,
                       'bio':bioController.text,
                       'photoUrl':photoUrl,
                     });

                     if(userCred!=null){
                       print('Success');
                       toastMessages('User registered Successfully!', true);
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(name: userCred.user!.displayName.toString(),)));

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

  void selectImage() async{
    Uint8List im =await pickImage(ImageSource.gallery);
    setState(() {
      _image=im;
    });
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
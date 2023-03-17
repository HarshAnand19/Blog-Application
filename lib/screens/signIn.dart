import 'dart:developer';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool showSpinner = false;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
    String email="",password="";

FirebaseAuth _auth=FirebaseAuth.instance;
   final _formkey=GlobalKey<FormState>();

  bool showPassword=false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a new Account'),
          centerTitle: true,
        ),
        body: Padding(
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

               RoundButton(title: 'Register', onPress: () async {
                 if(_formkey.currentState!.validate()){

                   setState(() {
                     showSpinner=true;
                   });
                   try{
                   final user=await _auth.createUserWithEmailAndPassword
                     (email: email.toString().trim(), password: password.toString().trim());

                   if(user!=null){
                     print('Success');
                     toastMessages('User registered Successfully!', true);
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(name: user.user!.displayName.toString(),)));

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
               })
             ],
           )
           ),
       )
            ],
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

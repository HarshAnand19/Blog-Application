import 'package:blog_app/components/elevated%20button.dart';
import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/options_login.dart';
import 'package:blog_app/screens/signIn.dart';
import 'package:blog_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {

  _handleGoogleBtn(){
    _signInWithGoogle().then((user) =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen(name: 'Harsh')))
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  @override
  Widget build(BuildContext context) {
 mq=MediaQuery.of(context).size;
    return Scaffold(

      body:SafeArea(
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Image.asset('assets/images/blogginglogo-removebg-preview.png',color: Colors.deepOrange,),
              SizedBox(height:mq.height*.02,),

              Text("Join our Blog",style: TextStyle(fontSize: 30),),


              SizedBox(height:mq.height*.06,),


             Center(
               child: ElevButton(text: 'Sign up with Email',icon: 'assets/images/mail.png', onPress:(){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
               }),
             ),

              SizedBox(height: mq.height*.02,),

              ElevButton(text: 'Sign up with Google',
                  onPress: _handleGoogleBtn,
                  icon:'assets/images/googleimg.png' ),

             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Text('Already have an Account?',style: TextStyle(fontSize:14)),
                 TextButton(onPressed: (){
                   Navigator.push(context,MaterialPageRoute(builder: (context)=>Options_Login()));
                 },
                     child: Text('Sign In',
                       style: TextStyle(color: Colors.blue,fontSize:16,fontWeight: FontWeight.bold),))
               ],
             )
            ],
          ),
        ),
      )
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

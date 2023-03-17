import 'package:blog_app/components/elevated%20button.dart';
import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/forgot_password.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/screens/signIn.dart';
import 'package:blog_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class Options_Login extends StatefulWidget {
  const Options_Login({Key? key}) : super(key: key);

  @override
  State<Options_Login> createState() => _Options_LoginState();
}

class _Options_LoginState extends State<Options_Login> {

  signInwithGoogle() async {
    try{
      final googleSignIn=GoogleSignIn();
      final user=await googleSignIn.signIn();

      //check whether user has any data
      if(user!=null){
        print('username +${user.displayName}');
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(name:user.displayName.toString())));
      }else{
        toastMessages('Sign In Failed!', false);
      }

    }catch(e){
      toastMessages(e.toString(), false);
    }

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

                Text("Welcome Back.",style: TextStyle(fontSize: 30),),


                SizedBox(height:mq.height*.06,),


                Center(
                  child: ElevButton(text: 'Sign in with Email',icon: 'assets/images/mail.png', onPress:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }),
                ),

                SizedBox(height: mq.height*.02,),

                ElevButton(text: 'Sign in with Google',
                    onPress: signInwithGoogle,
                    icon:'assets/images/googleimg.png' ),

                SizedBox(height: mq.height*.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Don't have an Account?",style: TextStyle(fontSize:14)),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OptionScreen()));
                    },
                        child: Text('Sign Up',
                          style: TextStyle(color: Colors.blue,fontSize:16,fontWeight: FontWeight.bold),))
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forget Password?",style: TextStyle(fontSize:14)),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));

                    },
                        child: Text('Recover Here',
                          style: TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.bold),))
                  ],
                ),

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

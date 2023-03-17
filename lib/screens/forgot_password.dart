import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showSpinner = false;
  TextEditingController emailController=TextEditingController();
  String email="";

  FirebaseAuth _auth=FirebaseAuth.instance;
  final _formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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


                        //login button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: RoundButton(title: 'Recover Password', onPress: () async {
                            if(_formkey.currentState!.validate()){

                              setState(() {
                                showSpinner=true;
                              });
                              try{
                                _auth.sendPasswordResetEmail(email: emailController.text.toString()).
                            then((value){
                              toastMessages('Reset Link Sent to Registered Email!', true);
                              setState(() {
                                showSpinner=false;
                              });
                                }).
                            onError((error, stackTrace) {
                              toastMessages(error.toString(),false);
                              setState(() {
                                showSpinner=false;
                              });
                                });

                              }catch(e){
                                print(e.toString());
                                toastMessages(e.toString(),false);
                                setState(() {
                                  showSpinner=false;
                                });
                              }
                            }
                          }),
                        ),



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

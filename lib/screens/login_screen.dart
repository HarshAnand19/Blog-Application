import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/forgot_password.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  String _email="",_password="";

  FirebaseAuth _auth=FirebaseAuth.instance;
  final _formkey=GlobalKey<FormState>();

  bool showPassword=false;

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login in your Existing Account'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [

                        //email field
                        TextFormField(
                          controller:_emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email)
                          ),
                          onChanged: (String value){
                            _email=value;

                          },
                          validator: (value){
                            return value!.isEmpty?'enter email':null;
                          },
                        ),


                        //password field
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: TextFormField(
                            controller:_passwordController,
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
                              _password=value;
                            },
                            validator: (value){
                              return value!.isEmpty?'enter password':null;
                            },
                          ),
                        ),

                        //login button
                        RoundButton(title: 'Login',

                            onPress: () async {
                          if(_formkey.currentState!.validate()){

                            setState(() {
                              showSpinner=true;
                            });
                            try{
                              final user=await _auth.signInWithEmailAndPassword
                                (email: _email.toString().trim(), password: _password.toString().trim());

                              if(user!=null){
                                print('Success');
                                toastMessages('User Login Successfully!', true);
                                setState(() {
                                  showSpinner=false;
                                });
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(name: user.user!.displayName.toString(),)));
                              }

                            }catch(e){
                              print(e.toString());
                              toastMessages(e.toString(),false);
                              setState(() {
                                _passwordController.text="";
                                showSpinner=false;
                              });
                            }
                          }
                        }),

                    //forgot password
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:Text('Forgot Password ?',style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account?"),
                        TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>RegisterScreen()));
                            }, child: Text("Sign Up"))
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
}


import 'dart:typed_data';

import 'package:blog_app/models/user.dart';
import 'package:blog_app/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async{
    User currentUser =_auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snap);
  }

  //sign up the user
  Future<String> signUpUser({
    required  String email1,
    required String password1,
    required String username,
    required String bio,
    required Uint8List file,
  }) async{
    String res ="Some error occured";

    try{
      if(email1.isNotEmpty || password1.isNotEmpty || username.isNotEmpty || bio.isNotEmpty){

        //register the user
        UserCredential userCredential =await  _auth.createUserWithEmailAndPassword(email: email1, password: password1);

        print(userCredential.user!.uid);

        String photoUrl=await StorageMethods().uploadImage('profilePic', file, false);
        //add user to database

        UserModel user=UserModel(
          username:username,
          uid:userCredential.user!.uid,
          email:email1,
          bio:bio,
          photoUrl:photoUrl,
        );
        await  _firestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());

        res="Success";
      }

    }
    catch(err){
      res=err.toString();
    }
    return res;
  }

//logging in the user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async
  {
    String res="Some error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res="success";
      }else{
        res="Please Enter all the fields";
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }

//sign out user
  Future<void> signOut() async{
    await _auth.signOut();
  }
}
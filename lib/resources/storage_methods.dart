
import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage =FirebaseStorage.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //adding images to firebase storage
  Future<String> uploadImage(String childName,Uint8List file,bool isPost) async {


    Reference ref=_storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost){
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask= ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl =await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //adding images to firebase storage
  Future<String> uploadImageFile(String childName,File file,bool isPost) async {
    Reference ref=_storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost){
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask= ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl =await snap.ref.getDownloadURL();
    return downloadUrl;
  }


//update profile picture of user
   Future<void> updateProfilePicture(File file,BuildContext context) async {

  try{
    //storage file ref with path
    final ref = _storage.ref().child('profilePic').child(_auth.currentUser!.uid);

    await ref.putFile(file);
    String downloadUrl =await ref.getDownloadURL();


    await _firestore.collection('users').doc(_auth.currentUser!.uid)
        .update({
      'photoUrl':downloadUrl
    }).then((value) =>showSnackBar("Profile Picture Updated Successfully", context)).
     onError((error, stackTrace) => showSnackBar(error.toString(), context));
  }catch(e){
    showSnackBar(e.toString(),context);
  }
  }
}
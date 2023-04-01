
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;

  const UserModel({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
  });

  Map<String,dynamic> toJson() =>{
    'username':username,
    'uid':uid,
    'email':email,
    'photoUrl':photoUrl,
    'bio':bio,
  };

  //take Document Snapshot return User Model
  static UserModel fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return UserModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],

    );
  }
}
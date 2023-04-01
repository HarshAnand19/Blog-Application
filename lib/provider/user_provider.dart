
import 'package:blog_app/models/user.dart';
import 'package:blog_app/resources/auth_methods.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async{
    UserModel user =await _authMethods.getUserDetails();
    _userModel =user;
    notifyListeners();
  }
}
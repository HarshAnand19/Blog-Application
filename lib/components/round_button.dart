import 'package:blog_app/main.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
   RoundButton({Key? key, required this.title, required this.onPress}) : super(key: key);

   final String title;
   final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child:MaterialButton(
        minWidth: double.infinity,
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        height: mq.height*.06,
        onPressed:  onPress,
        child: Text(title,style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

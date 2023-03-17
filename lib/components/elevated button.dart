import 'package:flutter/material.dart';

import '../main.dart';

class ElevButton extends StatelessWidget {
 final String text;
 final VoidCallback onPress;
 final String icon;

  const ElevButton({Key? key, required this.text, required this.onPress, required this.icon}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style:ElevatedButton.styleFrom(
        side:const BorderSide(width: 1, color: Colors.black),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        backgroundColor: Colors.white,
        shape: StadiumBorder(),
        elevation: 1,
      ),

      onPressed:  onPress,
      icon:Image.asset(icon,height: mq.height*.03,),
      label:Padding(
        padding: const EdgeInsets.only(left: 10),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black,fontSize: 16),
            children: [
              TextSpan(text:text,style: TextStyle(fontWeight: FontWeight.w500)),
            ]
        ),
        ),
      ),
    );
  }
}

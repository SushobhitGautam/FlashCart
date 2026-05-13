import 'package:flashcart_new_1/repository/widgets/uihelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomRoundedButton extends StatelessWidget {
  VoidCallback onTap;
  double mWidth;
  double mHeight;
  Color bgColor;
  String text;
  String? mIconPath;
  Color textColor;
  bool isOutlined;
MyCustomRoundedButton({required this.onTap,
  required this.text,
  this.mIconPath,
  this.textColor=Colors.black,
  this.mWidth=300,
  this.mHeight=50,
  this.bgColor=Colors.black,
  this.isOutlined=true,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width:mWidth ,
        height:mHeight ,
         child: mIconPath!=null? Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             SizedBox(width: 15,),
           Image.asset(mIconPath!,width: 40,height: 40,),
             Expanded(child: Center(child: Text(text,style: TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w500),))),
           ],)
             : Expanded(child: Center(child:Text(text,style: TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w500),))),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(25),
           color: isOutlined?Colors.red.shade800: bgColor,
           border: isOutlined? Border.all(
             width: 1.5,
             color: isOutlined?Colors.black:Colors.transparent
           ):null
         ),
      ),
    );
  }
}

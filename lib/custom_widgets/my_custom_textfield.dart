import 'package:flashcart_new_1/domain/constants/app_colors.dart';
import 'package:flashcart_new_1/domain/constants/appcolors.dart' show AppColors;
import 'package:flutter/material.dart';

InputDecoration getCreateAccTextFieldDecoration(){
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey,
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    ),
   focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: BorderSide(
    color: Colors.white,
    width: 2,
    )
   ),
  );
}
InputDecoration getSearchArtistTextFieldDecoration({IconData mIcon=Icons.search_sharp,
  Color bgColor=Colors.white,
  String mText='Search'}){
  return InputDecoration(
    filled: true,
    hintText: mText,
    hintStyle: TextStyle(color: Colors.white),
    prefixIcon: Icon(mIcon),
    fillColor: bgColor,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
    )
  );
}

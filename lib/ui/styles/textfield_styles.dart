import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String labelText){
  return InputDecoration(fillColor: const Color(0xFFFF6624).withOpacity(0.1), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10)), labelText: labelText, labelStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black,),
          borderRadius: BorderRadius.circular(10),
      ),
      alignLabelWithHint : true,
      floatingLabelBehavior: FloatingLabelBehavior.auto);
}
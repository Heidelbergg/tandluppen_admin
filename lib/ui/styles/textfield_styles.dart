import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String labelText){
  return InputDecoration(fillColor: const Color(0xFFFF6624).withOpacity(0.05), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder:
      OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10)), labelText: labelText, labelStyle: const TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black,),
          borderRadius: BorderRadius.circular(10),
      ),
      alignLabelWithHint : true,
      floatingLabelBehavior: FloatingLabelBehavior.auto);
}
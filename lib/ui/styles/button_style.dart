import 'package:flutter/material.dart';

ButtonStyle greenButtonStyle = ButtonStyle(
    minimumSize: MaterialStateProperty.all(const Size(400, 75)),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    elevation: MaterialStateProperty.all(3),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
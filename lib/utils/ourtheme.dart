import 'package:flutter/material.dart';

class OurTheme{
  ThemeData buildTheme(){
    Color lightGreen=const Color.fromARGB(255, 213, 235, 220);
    Color lightGrey=const Color.fromARGB(255, 164, 164, 164);
    Color darkGrey=const Color.fromARGB(255, 115, 124, 135);
    return ThemeData(
      canvasColor: lightGreen,
      primaryColor: lightGreen,
      secondaryHeaderColor: darkGrey,
        hintColor: lightGrey,
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: lightGrey
      )),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: lightGreen
        )
      ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: darkGrey,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        minWidth: 150,
        height: 40,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightGrey)
    );
  }
}
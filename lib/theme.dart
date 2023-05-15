// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData LightTheme(BuildContext context) => ThemeData(
        //brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.lato().fontFamily,
        cardColor:
            Colors.white, //primaryTextTheme: GoogleFonts.latoTextTheme(),
        canvasColor: creamColor,
        // ignore: deprecated_member_use
        buttonColor: Colors.indigo,
        // ignore: deprecated_member_use
        accentColor: Color.fromARGB(255, 14, 2, 82),
        tabBarTheme: TabBarTheme(labelColor: Color.fromARGB(255, 20, 1, 54)),
        appBarTheme: AppBarTheme(
          // on every page it will be used
          iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
          color:
              Theme.of(context).colorScheme.surface, //alternative of texttheme
          elevation: 0.0, // to remove shadow below appbar
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 24 //alternative of texttheme
              ),
        ),
      );
  static ThemeData DarkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.lato().fontFamily,
      cardColor: Colors.black,
      canvasColor: darkcreamColor,
      // ignore: deprecated_member_use
      buttonColor: Colors.indigo,
      // ignore: deprecated_member_use
      accentColor: Colors.white,
      //primaryTextTheme: GoogleFonts.latoTextTheme(),
      appBarTheme: AppBarTheme(
          // on every page it will be used
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.indigo, //alternative of texttheme
          elevation: 0.0, // to remove shadow below appbar
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 24 //alternative of texttheme
              ),
          // ignore: deprecated_member_use
          textTheme: Theme.of(context).textTheme));

  //colors
  static Color darkbluishColor = Color.fromARGB(255, 16, 0, 73);
  static Color creamColor = Color(0xfff5f5f5);
  static Color darkcreamColor = Color.fromARGB(255, 37, 45, 63);
  static Color lightblueColor = Color.fromARGB(255, 114, 94, 233);
}

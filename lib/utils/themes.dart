import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightThem(BuildContext context) => ThemeData(
      primarySwatch: Colors.blueGrey,
      fontFamily: GoogleFonts.lato().fontFamily,
      // buttonColor: Colors.blue,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ));

  static ThemeData darkThem(BuildContext context) => ThemeData(
      // Color c = Colors.deepOrange;
      // buttonColor: Colors.blueGrey,
      primarySwatch: Colors.blueGrey,
      fontFamily: GoogleFonts.lato().fontFamily);
}

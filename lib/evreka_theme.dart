import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/contants.dart';

class EvrekaTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: lightTextTheme,
    );
  }

  static TextTheme lightTextTheme = TextTheme(
    //Open Sans Regular — 16pt — #535A72 -- T1
    bodyText1: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: AppColor.DarkGrey.color,
    ),
    //Open Sans Regular — 20pt — #535A72 -- T2
    bodyText2: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: AppColor.DarkGrey.color,
    ),

    //Open Sans Extra Bold— 20pt — #172C49 -- H3
    headline3: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w800,
      color: AppColor.DarkBlue.color,
    ),

    //Open Sans Extra Bold— 16pt — #535A72 DarkGrey -- H4
    headline4: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w800,
      color: AppColor.DarkGrey.color,
    ),
  );
}

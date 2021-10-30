import 'package:flutter/material.dart';

class AppConstant {
  /// App Strings
  static String relocateSuccesfullMessage =
      'Your bin has been relocated succesfully!';
  static String navigate = 'NAVIGATE';
  static String relocate = 'RELOCATE';
  static String save = 'SAVE';
  static String login = 'LOGIN';
  static String username = 'Username';
  static String password = 'Password';
  static String errorMessage = 'There is no such username!';
  static String relocationInforCardText =
      'Please select a location from the map for your bin to be relocated. You can select a location by tapping on the map.';
  static String loginScreenMessage =
      'Please enter your user name and password.';

  /// Asset urls
  static String urlClearPng = 'assets/clear.png';
  static String urlLogoPng = 'assets/logo.png';
  static String urlBatteryBinPng = 'assets/battery_bin.png';
  static String urlErrorPng = 'assets/error.png';
  static String urlHouseholdBinPng = 'assets/household_bin.png';
  static String urlPasswordPng = 'assets/password.png';
}

///TODO: Apply color for all possible options
enum AppColor {
  DarkGrey,
  Yellow,
  Green,
  ShadowColorGreen,
  LightColor,
  ShadowColor,
  DarkBlue,
  ErrorColor,
  BorderColor,
}

extension AppColorExt on AppColor {
  Color get color {
    switch (this) {
      case AppColor.DarkGrey:
        return Color(0XFF535A72);
      case AppColor.Yellow:
        return Color(0XFFE9CF30);
      case AppColor.Green:
        return Color(0XFF3BA935);
      case AppColor.ShadowColorGreen:
        return Color(0XFF72C875);
      case AppColor.LightColor:
        return Color(0XFFFBFCFF);
      case AppColor.ShadowColor:
        return Color(0XFFBBBBBB);
      case AppColor.DarkBlue:
        return Color(0XFF172C49);
      case AppColor.ErrorColor:
        return Color(0XFFFC3131);
      case AppColor.BorderColor:
        return Color(0XFFE1E1E1);
    }
  }
}

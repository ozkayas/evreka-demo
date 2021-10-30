import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/authentication/login.dart';
import 'package:google_map_i/cluster_map.dart';
import 'package:google_map_i/operation/operation_screen.dart';

import 'evreka_theme.dart';

///TODO: izmir koordinatlarini belirle
///yeni bir firebase veritabani container100 adinda ve container1000 olarak baslat
///aralikta 100 adet container dummy data olustur
///aralikte 1000 adet dummy data olustur
///
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ///TODO: Set prefereed orientation
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      //statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent)); // transparent status bar
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final theme = EvrekaTheme.light();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Unknown Problem Occured'));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Container Tracker',

            theme: theme,

            //home: OperationScreen(),
            //home: LoginScreen(),
            home: MapSample(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

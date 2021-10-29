import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/contants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFECECEC), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
                child: Image.asset('assets/logo.png')),
            Text(
              AppConstant.loginScreenMessage,
              style: TextStyle(fontSize: 20),
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  cursorHeight: 20,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      // border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFFE9CF30))),
                      //suffixIcon: Icon(Icons.star),
                      labelText: AppConstant.username,
                      labelStyle:
                          TextStyle(fontSize: 16, color: Color(0xFFBBBBBB))),
                ),
                SizedBox(height: 20),
                TextFormField(),
                SizedBox(height: 50),
                Center(child: _cardButton(() {}, AppConstant.login))
              ],
            ))
          ],
        ),
      ),
    ));
  }

  Container _cardButton(Function onTap, String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFF72C875),
          spreadRadius: 0,
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ]),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            primary: Color(0xFF3BA935),
          ),
          onPressed: () {
            onTap();
          },
          child: Text(
            title,
            style: GoogleFonts.openSans(
                color: Color(0xFFFBFCFF),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_i/contants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(flex: 130),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.44,
                    child: Image.asset(AppConstant.logoPng)),
                Spacer(flex: 80),
                Text(
                  AppConstant.loginScreenMessage,
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(flex: 56),
                Form(
                    child: Column(
                  children: [
                    textFormField(
                        controller: _usernameCtr,
                        suffixFunction: _usernameCtr.clear,
                        suffixImage: AppConstant.clearPng,
                        labelText: AppConstant.username),
                    SizedBox(height: 45),
                    textFormField(
                        controller: _passwordCtr,
                        suffixFunction: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        suffixImage: AppConstant.passwordPng,
                        labelText: AppConstant.password,
                        obscureText: _isObscure),
                    SizedBox(height: 220),
                    Center(
                        child: _loginButton(
                            () {},
                            AppConstant.login,
                            _usernameCtr.text.isNotEmpty &&
                                _passwordCtr.text.isNotEmpty))
                  ],
                ))
              ],
            ),
          ),
        ));
  }

  TextFormField textFormField(
      {required TextEditingController controller,
      required String suffixImage,
      required Function suffixFunction,
      required String labelText,
      bool obscureText = false}) {
    return TextFormField(
      obscuringCharacter: '*',
      obscureText: obscureText,
      controller: controller,
      cursorHeight: 20,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          suffix: GestureDetector(
              onTap: () {
                suffixFunction();
              },
              child: Image.asset(suffixImage)),
          // border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFFE9CF30))),
          //suffixIcon: Icon(Icons.star),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 16, color: Color(0xFFBBBBBB))),
    );
  }

  Widget _loginButton(Function onTap, String title, bool enabled) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: Container(
        height: 43,
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
            onPressed: enabled
                ? () {
                    onTap();
                  }
                : () {},
            child: Text(
              title,
              style: GoogleFonts.openSans(
                  color: Color(0xFFFBFCFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:google_map_i/authentication/login_viewmodel.dart';
import 'package:google_map_i/connectivity/connectivity_service.dart';
import 'package:google_map_i/contants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel _viewModel = Get.put(LoginViewModel());
  final TextEditingController _usernameCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isObscure = true;
  bool _loginError = false;

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    Loader.hide();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double paddingValue = (MediaQuery.of(context).size.width - 300) / 2;
    var outerPadding =
        EdgeInsets.fromLTRB(paddingValue, 0, paddingValue - 9, paddingValue);
    const boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xFFECECEC), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
    );

    return FutureBuilder<ConnectivityStatus>(
        future: ConnectivityService().hasConnection(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return WaitingLoaderWidget();
          } else {
            if (snapshot.data == ConnectivityStatus.CellularNoNet ||
                snapshot.data == ConnectivityStatus.WifiNoNet) {
              return NoNetworkWidget();
            } else if (snapshot.data == ConnectivityStatus.Offline) {
              return OfflineDevice();
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    Container(
                      height: height,
                      width: width,
                      decoration: boxDecoration,
                      child: Padding(
                        padding: outerPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Spacer(flex: 130),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: Image.asset(AppConstant.urlLogoPng)),
                            Spacer(flex: 80),
                            Text(AppConstant.loginScreenMessage,
                                style: textTheme.bodyText2),
                            Spacer(flex: 56),
                            Form(
                                child: Column(
                              children: [
                                textFormField(
                                  controller: _usernameCtr,
                                  suffixFunction: _usernameCtr.clear,
                                  focusNode: _usernameFocus,
                                  labelText: AppConstant.username,
                                  textTheme: textTheme,
                                ),
                                SizedBox(height: 45),
                                textFormField(
                                    controller: _passwordCtr,
                                    suffixFunction: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    focusNode: _passwordFocus,
                                    labelText: AppConstant.password,
                                    textTheme: textTheme,
                                    obscureText: _isObscure),
                                SizedBox(height: 220),
                                Center(
                                  child: _loginButton(
                                      handleLogin,
                                      AppConstant.login,
                                      _usernameCtr.text.isNotEmpty &&
                                          _passwordCtr.text.isNotEmpty,
                                      textTheme),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    if (_loginError) buildErrorDialog(textTheme)
                  ],
                ),
              );
            }
          }
        });
  }

  handleLogin() async {
    Loader.show(context,
        progressIndicator: CircularProgressIndicator(
          color: AppColor.Green.color,
        ));
    var loginResult =
        await _viewModel.loginUser(_usernameCtr.text, _passwordCtr.text);
    Loader.hide();
    if (loginResult == false) {
      showLoginErrorDialog();
    }
  }

  void showLoginErrorDialog() async {
    setState(() {
      _loginError = true;
    });
    await Future.delayed(
      Duration(seconds: 3),
    );
    setState(() {
      _loginError = false;
    });
  }

  Widget textFormField(
      {required TextEditingController controller,
      required FocusNode focusNode,
      required Function suffixFunction,
      required String labelText,
      required TextTheme textTheme,
      bool obscureText = false}) {
    Widget getSuffixIcon() {
      if (labelText == AppConstant.password) {
        if (_isObscure) {
          return ImageIcon(
            AssetImage(AppConstant.urlPasswordPng),
            color: AppColor.ShadowColor.color,
          );
        } else {
          return ImageIcon(
            AssetImage(AppConstant.urlPasswordPng),
            color: AppColor.Yellow.color,
          );
        }
      } else {
        if (_loginError) {
          return ImageIcon(
            AssetImage(AppConstant.urlErrorPng),
            color: AppColor.ErrorColor.color,
          );
        } else {
          return ImageIcon(
            AssetImage(AppConstant.urlClearPng),
            color: AppColor.ShadowColor.color,
          );
        }
      }
    }

    return Container(
      width: 300,
      child: TextFormField(
        focusNode: focusNode,
        style: (labelText == AppConstant.username && _loginError)
            ? textTheme.bodyText1!.copyWith(color: AppColor.ErrorColor.color)
            // ? TextStyle(color: AppColor.ErrorColor.color)
            // : null,
            : textTheme.bodyText1,
        obscuringCharacter: '*',
        obscureText: obscureText,
        controller: controller,
        cursorHeight: 20,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(3),
            suffix: GestureDetector(
              onTap: () {
                suffixFunction();
              },
              child: getSuffixIcon(),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: (labelText == AppConstant.username && _loginError)
                        ? AppColor.ErrorColor.color
                        : Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColor.Yellow.color)),
            labelText: labelText,
            labelStyle: TextStyle(
                fontSize: 16,
                color: (labelText == AppConstant.username && _loginError)
                    ? AppColor.ErrorColor.color
                    : focusNode.hasFocus
                        ? AppColor.DarkGrey.color
                        : AppColor.ShadowColor.color)),
      ),
    );
  }

  Widget _loginButton(
      Function onTap, String title, bool enabled, TextTheme textTheme) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          height: 43,
          width: 304,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: AppColor.ShadowColorGreen.color,
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
                primary: AppColor.Green.color,
              ),
              onPressed: () {
                onTap();
              },
              child: Text(title, style: textTheme.button)),
        ),
      ),
    );
  }

  Widget buildErrorDialog(TextTheme textTheme) {
    final BoxDecoration boxDecoration = BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.ShadowColor.color,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(2, 2), // changes position of shadow
          ),
          BoxShadow(
            color: AppColor.ShadowColor.color,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(-2, -2), // changes position of shadow
          )
        ],
        color: AppColor.LightColor.color,
        borderRadius: BorderRadius.circular(8.0));

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 104),
          padding: EdgeInsets.fromLTRB(16, 25, 24, 25),
          decoration: boxDecoration,
          //width: MediaQuery.of(context).size.width * 0.94,
          width: 336,
          //height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppConstant.urlErrorPng),
                  SizedBox(width: 12),
                  Text(
                    AppConstant.errorMessage,
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class WaitingLoaderWidget extends StatelessWidget {
  const WaitingLoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FractionallySizedBox(
      widthFactor: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            color: AppColor.ShadowColorGreen.color,
            backgroundColor: AppColor.ShadowColorGreen.color.withAlpha(120),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Connecting...'),
        ],
      ),
    )));
  }
}

class NoNetworkWidget extends StatelessWidget {
  const NoNetworkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Please check your network settings and try again later",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class OfflineDevice extends StatelessWidget {
  const OfflineDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Please turn on either Wifi or Cellular Network",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

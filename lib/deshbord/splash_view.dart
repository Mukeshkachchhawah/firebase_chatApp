import 'dart:async';

import 'package:chat_application/contans/app_png_logo.dart';
import 'package:chat_application/deshbord/user_account/login_view.dart';
import 'package:chat_application/screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  static const String LOGIN_KEY = "loginKey";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppPngLogo.chatLogo,
          scale: 5,
        ),
      ),
    );
  }

  void sharedPref() async {
    var pref = await SharedPreferences.getInstance();

    var isLogin = pref.getBool(LOGIN_KEY);

    Timer(
      const Duration(seconds: 2),
      () {
        if (isLogin != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ));
        }
      },
    );
  }
}

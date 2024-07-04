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
  static const String LOGIN_KEY = "is_logged_in";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkLoginStatus();
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

  Future<void> _checkLoginStatus() async {
    var sp = await SharedPreferences.getInstance();
    bool isLoggedIn = sp.getBool(LOGIN_KEY) ?? false;

    Timer(
      const Duration(seconds: 3),
      () {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

import '../views/login_page.dart';

class SplashScreenController {
  void navigateToLoginPage(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
    });
  }
}

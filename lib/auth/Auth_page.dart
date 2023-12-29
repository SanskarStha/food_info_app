import 'package:flutter/material.dart';
import 'package:food_info_app/screens/signin_screen.dart';
import 'package:food_info_app/screens/signup_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //intially, show the login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInScreen(showRegisterPage: toggleScreens);
    } else {
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}

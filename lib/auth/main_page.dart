import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/auth/Auth_page.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/screens/signin_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreen(text: "");
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}

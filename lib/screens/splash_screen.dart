import 'package:food_info_app/auth/main_page.dart';
import 'package:food_info_app/providers/all_providers.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdBarcode.getSound();
      provdBarcode.getVibration();
      Future.delayed(const Duration(milliseconds: 800))
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
              (route) => false));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/concept.png",
                width: 250,
              ),
            ],
          ),
        ],
      )),
    );
  }
}

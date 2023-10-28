import 'package:food_info_app/providers/all_providers.dart';
import 'package:food_info_app/screens/splash_screen.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  runApp(MultiProvider(providers: providersAll, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: appKey,
      title: 'Barcode and QRcode Scanner',
      theme: ThemeData(
        primarySwatch: primary,
      ),
      home: const SplashScreen(),
    );
  }
}

MaterialColor primary = Colors.indigo;

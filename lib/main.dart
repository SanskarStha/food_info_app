import 'package:food_info_app/providers/all_providers.dart';
import 'package:food_info_app/auth/main_page.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: const MainPage(),
    );
  }
}

MaterialColor primary = Colors.indigo;

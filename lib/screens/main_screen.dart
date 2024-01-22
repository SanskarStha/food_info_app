import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_info_app/main.dart';
import 'package:food_info_app/providers/barcode_provider.dart';
import 'package:food_info_app/screens/ocrscan_screen.dart';
import 'package:food_info_app/screens/profile_page.dart';
import 'package:food_info_app/screens/signin_screen.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:food_info_app/widgets/drawer_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food_info_app/screens/result_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  final String text;
  String OCRText = "";
  MainScreen({super.key, required this.text});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String barcodeString = "";
  String stringResponse = "";
  String additives = "";
  String allergens = "";
  String productStatus = "";
  final user = FirebaseAuth.instance.currentUser!;

  // Future apicall() async {
  //   additives = "";
  //   productStatus = "";
  //   http.Response response;

  //   response = await http.get(Uri.parse(
  //       "https://world.openfoodfacts.net/api/v2/product/$barcodeString?fields=additives_tags,allergens"));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       stringResponse = response.body.toString();
  //       Map<String, dynamic> jsonMap = jsonDecode(stringResponse);
  //       productStatus = jsonMap['status_verbose'];

  //       if (productStatus == "product found") {
  //         List<dynamic> additivesTags = jsonMap['product']['additives_tags'];
  //         // additives = additivesTags.join(',');
  //         additives = additivesTags
  //             .map((additive) => additive.toString().replaceAll("en:", ""))
  //             .join(',');
  //         print("additives: $additives");
  //         // allergens = jsonMap['product']['allergens'];
  //         // allergens =
  //         //     allergens.toString().replaceAll("en:", "").replaceAll("fr:", "");
  //       }
  //     });
  //   } else {
  //     setState(() {
  //       productStatus = "product not found";
  //     });
  //   }
  // }

  Future apicall() async {
    additives = "";
    productStatus = "";
    widget.OCRText = "";

    final QuerySnapshot productQuerySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('barcode', isEqualTo: barcodeString)
        .get();

    if (productQuerySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot productSnapshot = productQuerySnapshot.docs.first;
      setState(() {
        List<dynamic> additivesList =
            (productSnapshot.data() as Map<String, dynamic>)['additives'];
        additives = additivesList.join(',');
        productStatus = "product found";
      });
    } else {
      setState(() {
        productStatus = "product not found";
      });
    }
  }

  @override
  void initState() {
    // apicall();
    super.initState();
    widget.OCRText = widget.text;
    additives = widget.text;
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  // void logout() {
  //   FirebaseAuth.instance.signOut().then((value) {
  //     print("Signed Out");
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SignInScreen()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarcodeProvider>(builder: (context, barcode, child) {
      return Scaffold(
        key: mainKey,
        drawer: DrawerMain(
          onProfileTap: goToProfilePage,
          onSignOut: FirebaseAuth.instance.signOut,
        ),
        appBar: AppBar(
          title: const Text("Food Info"),
        ),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () async {
        //       await barcode.scanBarcodeNormal();
        //       barcodeString = barcode.barcodeScanRes;
        //       await apicall();
        //     },
        //     label: const Row(
        //       children: [
        //         Icon(Icons.qr_code),
        //         SizedBox(width: 6),
        //         Text(
        //           "Scan",
        //           style: TextStyle(fontSize: 16),
        //         )
        //       ],
        //     )),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                  onPressed: () async {
                    await barcode.scanBarcodeNormal();
                    barcodeString = barcode.barcodeScanRes;
                    await apicall();
                  },
                  label: const Row(
                    children: [
                      Icon(Icons.qr_code),
                      SizedBox(width: 6),
                      Text(
                        "Barcode Scan",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )),
              const SizedBox(
                  width:
                      10), // Adjust the spacing between the buttons as needed
              FloatingActionButton.extended(
                  onPressed: () async {
                    // Functionality for the second button
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OCRScanScreen(),
                      ),
                    );
                  },
                  label: const Row(
                    children: [
                      Icon(Icons.qr_code),
                      SizedBox(width: 6),
                      Text(
                        "OCR Scan",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )),
            ],
          ),
        ),

        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scanned Barcode",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: SelectableText(barcodeString,
                  style: const TextStyle(fontSize: 16)),
            ),
            const Text(
              "Additives",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: widget.OCRText != ""
                  ? SelectableText(
                      widget.OCRText,
                      style: const TextStyle(fontSize: 16),
                    )
                  : additives.isEmpty && productStatus == "product found"
                      ? const Text("No Additives found",
                          style: TextStyle(fontSize: 16))
                      : productStatus == "product not found"
                          ? const Text(
                              "Product not found",
                              style: TextStyle(fontSize: 16),
                            )
                          : SelectableText(additives,
                              style: const TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: additives.isNotEmpty &&
                      additives != "No Additives found"
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                              additivesName: additives), // Pass additives data
                        ),
                      );
                    }
                  : null,
              child: const Text('Results'),
            ),
          ],
        )),
      );
    });
  }
}

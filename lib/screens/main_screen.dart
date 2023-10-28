import 'package:food_info_app/main.dart';
import 'package:food_info_app/providers/barcode_provider.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:food_info_app/widgets/drawer_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String barcodeString = "";
String stringResponse = "";
String additives = "";
String allergens = "";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "https://world.openfoodfacts.net/api/v2/product/$barcodeString?fields=additives_tags,allergens"));

    if (response.statusCode == 200) {
      setState(() {
        additives = "";

        stringResponse = response.body.toString();

        Map<String, dynamic> jsonMap = jsonDecode(stringResponse);
        List<dynamic> additivesTags = jsonMap['product']['additives_tags'];
        // additives = additivesTags.join(',');
        additives = additivesTags
            .map((additive) => additive.toString().replaceAll("en:", ""))
            .join(',');
        allergens = jsonMap['product']['allergens'];
        allergens =
            allergens.toString().replaceAll("en:", "").replaceAll("fr:", "");
        // for (var additive in additivesTags) {
        //   additives += ",$additive";
        //   print(additives);
        // }
        print(allergens);

        // additives = jsonDecode(stringResponse);
      });
    }
  }

  @override
  void initState() {
    // apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarcodeProvider>(builder: (context, barcode, child) {
      return Scaffold(
        key: mainKey,
        drawer: const DrawerMain(),
        appBar: AppBar(
          title: const Text("Barcode & QRcode Scanner"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await barcode.scanBarcodeNormal();
              barcodeString = barcode.barcodeScanRes;
              await apicall();
              print("hi");
              print('Scanned Barcode: $barcodeString');
              print("Additives: " + additives);
              print("Allergens: " + allergens);
            },
            label: Row(
              children: const [
                Icon(Icons.qr_code),
                SizedBox(width: 6),
                Text(
                  "Scan",
                  style: TextStyle(fontSize: 16),
                )
              ],
            )),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scanned Code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: SelectableText(barcode.barcodeScanRes,
                  style: const TextStyle(fontSize: 16)),
            ),
            const Text(
              "Additives",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: SelectableText(additives,
                  style: const TextStyle(fontSize: 16)),
            ),
            const Text(
              "Allergens",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: SelectableText(allergens,
                  style: const TextStyle(fontSize: 16)),
            )
          ],
        )),
      );
    });
  }
}
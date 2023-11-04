import 'package:food_info_app/main.dart';
import 'package:food_info_app/providers/barcode_provider.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:food_info_app/widgets/drawer_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food_info_app/screens/result_screen.dart';

String barcodeString = "";
String stringResponse = "";
String additives = "";
String allergens = "";
String productStatus = "";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future apicall() async {
    additives = "";
    productStatus = "";
    http.Response response;

    response = await http.get(Uri.parse(
        "https://world.openfoodfacts.net/api/v2/product/$barcodeString?fields=additives_tags,allergens"));

    if (response.statusCode == 200) {
      setState(() {
        stringResponse = response.body.toString();
        Map<String, dynamic> jsonMap = jsonDecode(stringResponse);
        productStatus = jsonMap['status_verbose'];

        if (productStatus == "product found") {
          List<dynamic> additivesTags = jsonMap['product']['additives_tags'];
          // additives = additivesTags.join(',');
          additives = additivesTags
              .map((additive) => additive.toString().replaceAll("en:", ""))
              .join(',');
          print("additives: $additives");
          // allergens = jsonMap['product']['allergens'];
          // allergens =
          //     allergens.toString().replaceAll("en:", "").replaceAll("fr:", "");
        }
      });
    } else {
      setState(() {
        productStatus = "product not found";
      });
    }
    print("barcode: $barcodeString");
    print("product status: $productStatus");
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
          title: const Text("Food Info"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
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
              constraints: const BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
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
              constraints: const BoxConstraints(minHeight: 108),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary)),
              child: additives.isEmpty && productStatus == "product found"
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
              onPressed: additives.isNotEmpty
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

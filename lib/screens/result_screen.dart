import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/screens/profile_page.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:food_info_app/widgets/drawer_main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

String barcodeString = "";
String stringResponse = "";
String allergens = "";

class ResultScreen extends StatefulWidget {
  final String additivesName;
  List<String> additives = [];

  ResultScreen({super.key, required this.additivesName});
  // const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // apicall();
    super.initState();
    // Split the additivesName string into a list of additives
    widget.additives = widget.additivesName.split(',');
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

  @override
  Widget build(BuildContext context) {
    final CollectionReference productInfoCollection =
        FirebaseFirestore.instance.collection('additives');
    return Scaffold(
      key: mainKey,
      drawer: DrawerMain(
        onProfileTap: goToProfilePage,
        onSignOut: FirebaseAuth.instance.signOut,
      ),
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.additives.length,
                itemBuilder: (context, index) {
                  final chemicalName = widget.additives[index];
                  return FutureBuilder<QuerySnapshot>(
                    future: productInfoCollection
                        .where('chemicalName', isEqualTo: chemicalName)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final data = snapshot.data?.docs;
                        if (data != null && data.isNotEmpty) {
                          final commonName = data.first['commonName'];
                          final chemicalName = data.first['chemicalName'];
                          final description = data.first['description'];
                          final effects = data.first['effects'];
                          final sources = data.first['sources'];
                          final harmful = data.first['harmful'];
                          final isVegan = data.first['isVegan'];
                          final isVegetarian = data.first['isVegetarian'];
                          final hasLactose = data.first['hasLactose'];
                          final hasNuts = data.first['hasNuts'];

                          return Card(
                            color: harmful
                                ? Colors.yellow
                                : Colors
                                    .green, // Set the card color based on the 'harmful' value
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Chemical Name:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(chemicalName,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Common Name:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(commonName,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Description:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(description,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Effects:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(effects,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  if (!isVegan)
                                    Text(
                                      "$chemicalName contains non-vegan ingredient.",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (!isVegetarian)
                                    Text(
                                      "$chemicalName contains non-vegetarian ingredient.",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (hasLactose)
                                    Text(
                                      "$chemicalName contains milk products.",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (hasNuts)
                                    Text(
                                      "$chemicalName contains nuts",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Sources:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children:
                                          sources.map<InlineSpan>((source) {
                                        if (source is String) {
                                          return TextSpan(
                                            children: [
                                              TextSpan(
                                                text: source,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(255, 5,
                                                      80, 141), // Link color
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        // Handle the URL click event here, e.g., open the URL in a browser
                                                        launchURL(source);
                                                      },
                                              ),
                                              const TextSpan(
                                                  text:
                                                      '\n'), // Add a line break
                                            ],
                                          );
                                        } else {
                                          // Handle cases where the source is not a string, e.g., you can display an error message.
                                          return const TextSpan(
                                            text: 'Invalid URL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          );
                                        }
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Card(
                            color: Colors
                                .grey, // Set the card color based on the 'harmful' value
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Chemical Name:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(chemicalName,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Common Name:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("Unknown",
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Effects:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("Unknown",
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Sources:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("Unknown",
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                ); // Navigate back to MainScreen
              },
              child: const Text("Scan Next"),
            ),
          ],
        ),
      ),
    );
  }
}

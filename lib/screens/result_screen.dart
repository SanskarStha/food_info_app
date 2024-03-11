import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/screens/profile_page.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:food_info_app/widgets/drawer_main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String barcodeString = "";
String stringResponse = "";
String allergens = "";
String gptChemicalName = "";
String gptCommonName = "";
String gptDescription = "";
String gptEffects = "";

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

  final Map<String, Future<Map<String, dynamic>>> _apiFutures = {};

  Future<Map<String, dynamic>> apicall2(String chemicalName) async {
    gptChemicalName = "";
    gptCommonName = "";
    gptDescription = "";
    gptEffects = "";

    const String baseUrl =
        "https://chatgpt.hkbu.edu.hk/general/rest/deployments/gpt-35-turbo/chat/completions?api-version=2023-12-01-preview";
    const String apiKey = "799142f8-9f76-4c6d-8fa2-dbb65d80929d";
    String conversation =
        'Provide me with information about the food additive $chemicalName . When providing information about a food additive, please adhere to the following format strictly:\n'
        '- Start with "chemicalName:" followed by the name that starts with "E",\n'
        '- Then write "commonName:" followed by the commonly known name,\n'
        '- Next, "description:" followed by a 2 to 3 sentences short description,\n'
        '- Finally, "effects:" followed by any known effects if applicable.\n'
        'For example, for the food additive named E422, the information should be presented as follows:\n'
        'chemicalName: E422 \n'
        'commonName: Glycerol \n'
        'description: Glycerol is a sugar alcohol that is clear, odorless, and sweet-tasting. It is a viscous liquid that is commonly derived from plant or animal fats and used as a food additive for its moisture-retaining and sweetening properties. \n'
        'effects: Glycerol is generally considered safe for consumption and has no known adverse effects when used in food. However, excessive intake may cause gastrointestinal disturbances such as diarrhea and excessive urination due to its osmotic effect. \n';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': conversation},
        ],
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      String gptResponse = jsonMap['choices'][0]['message']['content'];
      List<String> lines = gptResponse.trim().split("\n");
      return {
        'chemicalName': lines[0].split(": ")[1],
        'commonName': lines[1].split(": ")[1],
        'description': lines[2].split(": ")[1],
        'effects': lines[3].split(": ")[1],
      };
    } else {
      throw Exception("API not working");
    }
  }

  Future<Map<String, dynamic>> getChemicalInfo(String chemicalName) {
    if (!_apiFutures.containsKey(chemicalName)) {
      _apiFutures[chemicalName] = apicall2(chemicalName);
    }
    return _apiFutures[chemicalName] as Future<Map<String, dynamic>>;
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
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xFF14B86B),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text(
                    'Safe to consume    ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xFFFCFF5C),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text(
                    'Might be harmful    ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xFFA9A5B6),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text(
                    'AI source',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                                ? const Color(0xFFFCFF5C)
                                : const Color(
                                    0xFF14B86B), // Set the card color based on the 'harmful' value
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
                          // If Firestore data is not available, use FutureBuilder to wait for apicall2
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getChemicalInfo(
                                chemicalName), // Use the getChemicalInfo method
                            builder: (context,
                                AsyncSnapshot<Map<String, dynamic>>
                                    apiSnapshot) {
                              if (apiSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (apiSnapshot.hasError) {
                                // return Text('API Error: ${apiSnapshot.error}');
                                return const Text(
                                    ''); //Skipping the additive if the format of the response from API is unexpected
                              } else if (apiSnapshot.hasData) {
                                final apiData = apiSnapshot.data;
                                // Extracting the data received from the API
                                final String commonName =
                                    apiData?['commonName'] ?? 'Unknown';
                                final String description =
                                    apiData?['description'] ??
                                        'No description available';
                                final String chemicalName =
                                    apiData?['chemicalName'] ?? 'Unknown';
                                final String effects = apiData?['effects'] ??
                                    'No effects information available';
                                return Card(
                                  color: const Color(0xFFA9A5B6),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Chemical Name:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(chemicalName,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Common Name:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(commonName,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Description:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(description,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Effects:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(effects,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Sources:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("chatGPT",
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('No data available');
                              }
                            },
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
                    builder: (context) => MainScreen(text: ""),
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

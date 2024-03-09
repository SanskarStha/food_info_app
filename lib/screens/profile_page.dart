import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/widgets/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference productInfoCollection =
      FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

//   @override
//   Widget build(BuildContext context) {
//     final email = currentUser.email;
//     print(email);
//     return Scaffold(
//         appBar: AppBar(title: const Text("Profile Page")),
//         body: FutureBuilder<QuerySnapshot>(
//           future: productInfoCollection
//               .where('email', isEqualTo: currentUser.email)
//               .get(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               final data = snapshot.data?.docs;

//               if (data != null && data.isNotEmpty) {
//                 final userName = data.first['username'];
//                 final age = data.first['age'];
//                 final email = data.first['email'];
//                 var isVegan = data.first['vegan'];
//                 var isVegetarian = data.first['vegetarian'];
//                 var isLactoseIntolerant = data.first['lactose intolerant'];
//                 var hasNutAllergy = data.first['nut allergy'];

//                 return (ListView(
//                   children: [
//                     const SizedBox(height: 50),
//                     const Icon(
//                       Icons.person,
//                       size: 72,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       currentUser.email!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.indigo[700]),
//                     ),
//                     const SizedBox(height: 50),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 25.0),
//                       child: Text(
//                         'My Details',
//                         style:
//                             TextStyle(color: Colors.indigo[600], fontSize: 18),
//                       ),
//                     ),
//                     MyTextBox(
//                       text: userName.toString(),
//                       sectionName: 'username',
//                       onPressed: () => editField('username'),
//                     ),
//                     MyTextBox(
//                       text: age.toString(),
//                       sectionName: 'age',
//                       onPressed: () => editField('age'),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 25.0),
//                         child: Text(
//                           'Dietary Preferences',
//                           style: TextStyle(
//                               color: Colors.indigo[600], fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Card(
//                           color: Colors.grey[200],
//                           child: Column(
//                             children: [
//                               CheckboxListTile(
//                                 title: Text(
//                                   'Vegan',
//                                   style: TextStyle(
//                                       color: Colors.indigo[600], fontSize: 15),
//                                 ),
//                                 value: isVegan == 'true',
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     isVegan = newValue!;
//                                   });
//                                 },
//                               ),
//                               CheckboxListTile(
//                                 title: Text(
//                                   'Vegetarian',
//                                   style: TextStyle(
//                                       color: Colors.indigo[600], fontSize: 15),
//                                 ),
//                                 value: isVegetarian == 'true',
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     isVegetarian = newValue!;
//                                   });
//                                 },
//                               ),
//                               CheckboxListTile(
//                                 title: Text(
//                                   'Lactose Intolerant',
//                                   style: TextStyle(
//                                       color: Colors.indigo[600], fontSize: 15),
//                                 ),
//                                 value: isLactoseIntolerant == 'true',
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     isLactoseIntolerant = newValue!;
//                                   });
//                                 },
//                               ),
//                               CheckboxListTile(
//                                 title: Text(
//                                   'Nut Allergy',
//                                   style: TextStyle(
//                                       color: Colors.indigo[600], fontSize: 15),
//                                 ),
//                                 value: hasNutAllergy == 'true',
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     hasNutAllergy = newValue!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ))
//                   ],
//                 ));
//               } else {
//                 return Card(
//                   color: Colors
//                       .grey, // Set the card color based on the 'harmful' value
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                     ),
//                   ),
//                 );
//               }
//             }
//           },
//         ));
//   }
// }

  @override
  Widget build(BuildContext context) {
    final email = currentUser.email;
    print(email);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: FutureBuilder<QuerySnapshot>(
        future: productInfoCollection
            .where('email', isEqualTo: currentUser.email)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data?.docs;

            if (data != null && data.isNotEmpty) {
              final userName = data.first['username'];
              final age = data.first['age'];
              final email = data.first['email'];
              var isVegan = data.first['vegan'];
              var isVegetarian = data.first['vegetarian'];
              var isLactoseIntolerant = data.first['lactose intolerant'];
              var hasNutAllergy = data.first['nut allergy'];
              var hasTypeIIDiabetes = data.first['type II diabetes'];
              var hasHypertension = data.first['hypertension'];

              return ListView(
                children: [
                  const SizedBox(height: 30),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.indigo[700]),
                  ),
                  // const SizedBox(height: 50),
                  _buildDetailsSection(userName.toString(), age),
                  _buildPreferencesSection(
                    isVegan: isVegan == 'true',
                    isVegetarian: isVegetarian == 'true',
                    isLactoseIntolerant: isLactoseIntolerant == 'true',
                    hasNutAllergy: hasNutAllergy == 'true',
                  ),
                  _buildVulnerabilitiesSection(
                    hasTypeIIDiabetes: hasTypeIIDiabetes == 'true',
                    hasHypertension: hasHypertension == 'true',
                  )
                ],
              );
            } else {
              return Card(
                color: Colors
                    .grey, // Set the card color based on the 'harmful' value
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildDetailsSection(String userName, int age) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'My Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[600],
                ),
              ),
            ),
            ListTile(
              title: const Text('Username',
                  style: TextStyle(color: Colors.indigo)),
              subtitle:
                  Text(userName, style: const TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => editField('username'),
              ),
            ),
            ListTile(
              title: const Text('Age', style: TextStyle(color: Colors.indigo)),
              subtitle: Text(age.toString(),
                  style: const TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => editField('age'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection({
    required bool isVegan,
    required bool isVegetarian,
    required bool isLactoseIntolerant,
    required bool hasNutAllergy,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[600],
                ),
              ),
            ),
            _buildPreferenceSwitchTile(
              'Vegan',
              isVegan,
              (newValue) {
                setState(() {
                  isVegan = newValue;
                });
              },
            ),
            _buildPreferenceSwitchTile(
              'Vegetarian',
              isVegetarian,
              (newValue) {
                setState(() {
                  isVegetarian = newValue;
                });
              },
            ),
            _buildPreferenceSwitchTile(
              'Lactose Intolerant',
              isLactoseIntolerant,
              (newValue) {
                setState(() {
                  isLactoseIntolerant = newValue;
                });
              },
            ),
            _buildPreferenceSwitchTile(
              'Nut Allergy',
              hasNutAllergy,
              (newValue) {
                setState(() {
                  hasNutAllergy = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVulnerabilitiesSection({
    required bool hasTypeIIDiabetes,
    required bool hasHypertension,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vulnerabilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[600],
                ),
              ),
            ),
            _buildPreferenceSwitchTile(
              'Type II Diabetes',
              hasTypeIIDiabetes,
              (newValue) {
                setState(() {
                  hasTypeIIDiabetes = newValue;
                });
              },
            ),
            _buildPreferenceSwitchTile(
              'Hypertension',
              hasHypertension,
              (newValue) {
                setState(() {
                  hasHypertension = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.indigo),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      activeTrackColor: Colors.green.withOpacity(0.5),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withOpacity(0.5),
    );
  }
}

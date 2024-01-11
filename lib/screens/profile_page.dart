import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/widgets/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// class _ProfilePageState extends State<ProfilePage> {
//   final currentUser = FirebaseAuth.instance.currentUser!;

//   Future<void> editField(String field) async {}

//   @override
//   Widget build(BuildContext context) {
//     final email = currentUser.email;
//     print(email);
//     return Scaffold(
//       appBar: AppBar(title: Text("Profile Page")),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final userData = snapshot.data!.data() as Map<String, dynamic>;

//             return (ListView(
//               children: [
//                 const SizedBox(height: 50),
//                 Icon(
//                   Icons.person,
//                   size: 72,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   currentUser.email!,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.indigo[700]),
//                 ),
//                 const SizedBox(height: 50),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: Text(
//                     'My Details',
//                     style: TextStyle(color: Colors.indigo[600]),
//                   ),
//                 ),
//                 MyTextBox(
//                   text: userData['username'],
//                   sectionName: 'username',
//                   onPressed: () => editField('username'),
//                 ),
//                 MyTextBox(
//                   text: userData['age'],
//                   sectionName: 'age',
//                   onPressed: () => editField('age'),
//                 ),
//                 // const SizedBox(height: 50),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 25.0),
//                 //   child: Text(
//                 //     'My Preferences',
//                 //     style: TextStyle(color: Colors.indigo[600]),
//                 //   ),
//                 // ),
//               ],
//             ));
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error${snapshot.error}'),
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference productInfoCollection =
      FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    final email = currentUser.email;
    print(email);
    return Scaffold(
        appBar: AppBar(title: Text("Profile Page")),
        body: FutureBuilder<QuerySnapshot>(
          future: productInfoCollection
              .where('email', isEqualTo: currentUser.email)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return (ListView(
                  children: [
                    const SizedBox(height: 50),
                    Icon(
                      Icons.person,
                      size: 72,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.indigo[700]),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'My Details',
                        style:
                            TextStyle(color: Colors.indigo[600], fontSize: 18),
                      ),
                    ),
                    MyTextBox(
                      text: userName.toString(),
                      sectionName: 'username',
                      onPressed: () => editField('username'),
                    ),
                    MyTextBox(
                      text: age.toString(),
                      sectionName: 'age',
                      onPressed: () => editField('age'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Dietary Preferences',
                          style: TextStyle(
                              color: Colors.indigo[600], fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Card(
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  'Vegan',
                                  style: TextStyle(
                                      color: Colors.indigo[600], fontSize: 15),
                                ),
                                value: isVegan == 'true',
                                onChanged: (newValue) {
                                  setState(() {
                                    isVegan = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  'Vegetarian',
                                  style: TextStyle(
                                      color: Colors.indigo[600], fontSize: 15),
                                ),
                                value: isVegetarian == 'true',
                                onChanged: (newValue) {
                                  setState(() {
                                    isVegetarian = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  'Lactose Intolerant',
                                  style: TextStyle(
                                      color: Colors.indigo[600], fontSize: 15),
                                ),
                                value: isLactoseIntolerant == 'true',
                                onChanged: (newValue) {
                                  setState(() {
                                    isLactoseIntolerant = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  'Nut Allergy',
                                  style: TextStyle(
                                      color: Colors.indigo[600], fontSize: 15),
                                ),
                                value: hasNutAllergy == 'true',
                                onChanged: (newValue) {
                                  setState(() {
                                    hasNutAllergy = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ))

                    // const SizedBox(height: 50),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 25.0),
                    //   child: Text(
                    //     'My Preferences',
                    //     style: TextStyle(color: Colors.indigo[600]),
                    //   ),
                    // ),
                  ],
                ));
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
        ));
  }
}

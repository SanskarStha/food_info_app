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
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

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
                    style: TextStyle(color: Colors.indigo[600]),
                  ),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),
                MyTextBox(
                  text: userData['age'],
                  sectionName: 'age',
                  onPressed: () => editField('age'),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Preferences',
                    style: TextStyle(color: Colors.indigo[600]),
                  ),
                ),
              ],
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

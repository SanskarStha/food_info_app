import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/reusable_widgets/resuable_widget.dart';
import 'package:food_info_app/auth/main_page.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({
    super.key,
    required this.showLoginPage,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  // TextEditingController _confirmPasswordTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  bool isVegan = false;
  bool isVegetarian = false;
  bool isLactoseIntolerant = false;
  bool hasNutAllergy = false;
  bool hasTypeIIDiabetes = false;
  bool hasHypertension = false;

  Future signUp() async {
    // if (passwordConfirmed()) {
    // create user
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailTextController.text.trim(),
            password: _passwordTextController.text.trim())
        .then((value) {
      print("Created New Account");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });

    // add user details
    addUserDetails(
        _userNameTextController.text.trim(),
        int.parse(_ageTextController.text.trim()),
        _emailTextController.text.trim(),
        isVegan,
        isVegetarian,
        isLactoseIntolerant,
        hasNutAllergy,
        hasTypeIIDiabetes,
        hasHypertension);
  }

  Future addUserDetails(
      String userName,
      int age,
      String email,
      bool isVegan,
      bool isVegetarian,
      bool isLactoseIntolerant,
      bool hasNutAllergy,
      bool hasTypeIIDiabetes,
      bool hasHypertension) async {
    await FirebaseFirestore.instance.collection('users').add({
      'username': userName,
      'age': age,
      'email': email,
      'vegan': isVegan ? 'true' : 'false',
      'vegetarian': isVegetarian ? 'true' : 'false',
      'lactose intolerant': isLactoseIntolerant ? 'true' : 'false',
      'nut allergy': hasNutAllergy ? 'true' : 'false',
      'type II diabetes': hasTypeIIDiabetes ? 'true' : 'false',
      'hypertension': hasHypertension ? 'true' : 'false'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.indigo,
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter User Name", Icons.person_outline,
                    false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Age", Icons.person_outline, false,
                    _ageTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Weight (in kg)", Icons.person_outline,
                    false, _weightTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, false,
                    _passwordTextController),
                const SizedBox(height: 20),
                _buildPreferencesSection(),
                const SizedBox(height: 20),
                _buildVulnerabilitiesSection(),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  signUp();
                }),
                signInOption()
              ],
            ),
          ))),
    );
  }

  Widget _buildPreferencesSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo.shade300,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _buildPreferenceSwitchTile('Vegan', isVegan, (newValue) {
            setState(() {
              isVegan = newValue;
            });
          }),
          _buildPreferenceSwitchTile('Vegetarian', isVegetarian, (newValue) {
            setState(() {
              isVegetarian = newValue;
            });
          }),
          _buildPreferenceSwitchTile('Lactose Intolerant', isLactoseIntolerant,
              (newValue) {
            setState(() {
              isLactoseIntolerant = newValue;
            });
          }),
          _buildPreferenceSwitchTile('Nut Allergy', hasNutAllergy, (newValue) {
            setState(() {
              hasNutAllergy = newValue;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildVulnerabilitiesSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo.shade300,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Vulnerabilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _buildPreferenceSwitchTile('Type II Diabetes', hasTypeIIDiabetes,
              (newValue) {
            setState(() {
              hasTypeIIDiabetes = newValue;
            });
          }),
          _buildPreferenceSwitchTile('Hypertension', hasHypertension,
              (newValue) {
            setState(() {
              hasHypertension = newValue;
            });
          }),
        ],
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
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      activeTrackColor: Colors.green.withOpacity(0.5),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withOpacity(0.5),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("I am a member!", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: widget.showLoginPage,
          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

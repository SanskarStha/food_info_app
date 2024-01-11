import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/reusable_widgets/resuable_widget.dart';
import 'package:food_info_app/auth/main_page.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  // TextEditingController _confirmPasswordTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  bool isVegan = false;
  bool isVegetarian = false;
  bool isLactoseIntolerant = false;
  bool hasNutAllergy = false;

  @override
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
          context, MaterialPageRoute(builder: (context) => MainPage()));
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
        hasNutAllergy);
  }

  Future addUserDetails(String userName, int age, String email, bool isVegan,
      bool isVegetarian, bool isLactoseIntolerant, bool hasNutAllergy) async {
    await FirebaseFirestore.instance.collection('users').add({
      'username': userName,
      'age': age,
      'email': email,
      'vegan': isVegan ? 'true' : 'false',
      'vegetarian': isVegetarian ? 'true' : 'false',
      'lactose intolerant': isLactoseIntolerant ? 'true' : 'false',
      'nut allergy': hasNutAllergy ? 'true' : 'false'
    });
  }

  // bool passwordConfirmed() {
  //   if (_passwordTextController.text.trim() ==
  //       _confirmPasswordTextController.text.trim()) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
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
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, false,
                    _passwordTextController),
                // const SizedBox(
                //   height: 20,
                // ),
                // reusableTextField("Re-Enter Password", Icons.lock_outline,
                //     false, _confirmPasswordTextController),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: Text(
                    'Vegan',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: isVegan,
                  onChanged: (newValue) {
                    setState(() {
                      isVegan = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Vegetarian',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: isVegetarian,
                  onChanged: (newValue) {
                    setState(() {
                      isVegetarian = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Lactose Intolerant',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: isLactoseIntolerant,
                  onChanged: (newValue) {
                    setState(() {
                      isLactoseIntolerant = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Nut Allergy',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: hasNutAllergy,
                  onChanged: (newValue) {
                    setState(() {
                      hasNutAllergy = newValue!;
                    });
                  },
                ),
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

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("I am a member!", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: widget.showLoginPage,
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => SignUpScreen()));

          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

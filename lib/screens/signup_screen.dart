import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/reusable_widgets/resuable_widget.dart';
import 'package:food_info_app/auth/main_page.dart';

// class SignUpScreen extends StatefulWidget {
//   final VoidCallback showLoginPage;
//   const SignUpScreen({
//     super.key,
//     required this.showLoginPage,
//   });

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _passwordTextController = TextEditingController();
//   // TextEditingController _confirmPasswordTextController = TextEditingController();
//   final TextEditingController _userNameTextController = TextEditingController();
//   final TextEditingController _ageTextController = TextEditingController();
//   final TextEditingController _weightTextController = TextEditingController();
//   bool isVegan = false;
//   bool isVegetarian = false;
//   bool isLactoseIntolerant = false;
//   bool hasNutAllergy = false;
//   bool hasTypeIIDiabetes = false;
//   bool hasHypertension = false;

//   Future signUp() async {
//     // if (passwordConfirmed()) {
//     // create user
//     await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: _emailTextController.text.trim(),
//             password: _passwordTextController.text.trim())
//         .then((value) {
//       print("Created New Account");
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => const MainPage()));
//     }).onError((error, stackTrace) {
//       print("Error ${error.toString()}");
//     });

//     // add user details
//     addUserDetails(
//         _userNameTextController.text.trim(),
//         int.parse(_ageTextController.text.trim()),
//         _emailTextController.text.trim(),
//         isVegan,
//         isVegetarian,
//         isLactoseIntolerant,
//         hasNutAllergy,
//         hasTypeIIDiabetes,
//         hasHypertension);
//   }

//   Future addUserDetails(
//       String userName,
//       int age,
//       String email,
//       bool isVegan,
//       bool isVegetarian,
//       bool isLactoseIntolerant,
//       bool hasNutAllergy,
//       bool hasTypeIIDiabetes,
//       bool hasHypertension) async {
//     await FirebaseFirestore.instance.collection('users').add({
//       'username': userName,
//       'age': age,
//       'email': email,
//       'vegan': isVegan ? 'true' : 'false',
//       'vegetarian': isVegetarian ? 'true' : 'false',
//       'lactose intolerant': isLactoseIntolerant ? 'true' : 'false',
//       'nut allergy': hasNutAllergy ? 'true' : 'false',
//       'type II diabetes': hasTypeIIDiabetes ? 'true' : 'false',
//       'hypertension': hasHypertension ? 'true' : 'false'
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           "Sign Up",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: const BoxDecoration(
//             color: Colors.indigo,
//           ),
//           child: SingleChildScrollView(
//               child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
//             child: Column(
//               children: <Widget>[
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter User Name", Icons.person_outline,
//                     false, _userNameTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Age", Icons.person_outline, false,
//                     _ageTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Weight (in kg)", Icons.person_outline,
//                     false, _weightTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Email Id", Icons.person_outline, false,
//                     _emailTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Password", Icons.lock_outline, false,
//                     _passwordTextController),
//                 const SizedBox(height: 20),
//                 _buildPreferencesSection(),
//                 const SizedBox(height: 20),
//                 _buildVulnerabilitiesSection(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 signInSignUpButton(context, false, () {
//                   signUp();
//                 }),
//                 signInOption()
//               ],
//             ),
//           ))),
//     );
//   }

//   Widget _buildPreferencesSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.indigo.shade300,
//       ),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Preferences',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           _buildPreferenceSwitchTile('Vegan', isVegan, (newValue) {
//             setState(() {
//               isVegan = newValue;
//             });
//           }),
//           _buildPreferenceSwitchTile('Vegetarian', isVegetarian, (newValue) {
//             setState(() {
//               isVegetarian = newValue;
//             });
//           }),
//           _buildPreferenceSwitchTile('Lactose Intolerant', isLactoseIntolerant,
//               (newValue) {
//             setState(() {
//               isLactoseIntolerant = newValue;
//             });
//           }),
//           _buildPreferenceSwitchTile('Nut Allergy', hasNutAllergy, (newValue) {
//             setState(() {
//               hasNutAllergy = newValue;
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildVulnerabilitiesSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.indigo.shade300,
//       ),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Vulnerabilities',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           _buildPreferenceSwitchTile('Type II Diabetes', hasTypeIIDiabetes,
//               (newValue) {
//             setState(() {
//               hasTypeIIDiabetes = newValue;
//             });
//           }),
//           _buildPreferenceSwitchTile('Hypertension', hasHypertension,
//               (newValue) {
//             setState(() {
//               hasHypertension = newValue;
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildPreferenceSwitchTile(
//     String title,
//     bool value,
//     ValueChanged<bool> onChanged,
//   ) {
//     return SwitchListTile(
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white),
//       ),
//       value: value,
//       onChanged: onChanged,
//       activeColor: Colors.green,
//       activeTrackColor: Colors.green.withOpacity(0.5),
//       inactiveThumbColor: Colors.grey,
//       inactiveTrackColor: Colors.grey.withOpacity(0.5),
//     );
//   }

//   Row signInOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("I am a member!", style: TextStyle(color: Colors.white70)),
//         GestureDetector(
//           onTap: widget.showLoginPage,
//           child: const Text(
//             " Log In",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         )
//       ],
//     );
//   }
// }

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;

  const SignUpScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _navigateToPreferencesScreen(UserDetails userDetails) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PreferencesScreen(
          userDetails: userDetails, showLoginPage: widget.showLoginPage),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return UserDetailsScreen(
        onNext: _navigateToPreferencesScreen,
        showLoginPage: widget.showLoginPage);
  }
}

class UserDetailsScreen extends StatefulWidget {
  final Function(UserDetails) onNext;
  final VoidCallback showLoginPage;

  const UserDetailsScreen(
      {Key? key, required this.onNext, required this.showLoginPage})
      : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _heightTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up - Step 1",
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
                reusableTextField("Enter height (in cm)", Icons.person_outline,
                    false, _heightTextController),
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {
                      final userDetails = UserDetails(
                        username: _userNameTextController.text.trim(),
                        age: int.parse(_ageTextController.text.trim()),
                        weight: int.parse(_weightTextController.text.trim()),
                        height: int.parse(_heightTextController.text.trim()),
                        email: _emailTextController.text.trim(),
                        password: _passwordTextController.text.trim(),
                      );
                      widget.onNext(userDetails);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                signInOption(),
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
          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class UserDetails {
  final String username;
  final int age;
  final int weight;
  final int height;
  final String email;
  final String password;

  UserDetails({
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
    required this.email,
    required this.password,
  });
}

class PreferencesScreen extends StatefulWidget {
  final UserDetails userDetails;
  final VoidCallback showLoginPage;

  const PreferencesScreen(
      {Key? key, required this.userDetails, required this.showLoginPage})
      : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isVegan = false;
  bool isVegetarian = false;
  bool isLactoseIntolerant = false;
  bool hasNutAllergy = false;
  bool hasTypeIIDiabetes = false;
  bool hasHypertension = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up - Step 2",
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
              children: [
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

  Future signUp() async {
    // if (passwordConfirmed()) {
    // create user
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: widget.userDetails.email.trim(),
            password: widget.userDetails.password.trim())
        .then((value) {
      print("Created New Account");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });

    // add user details
    addUserDetails(
        widget.userDetails.username.trim(),
        widget.userDetails.age,
        widget.userDetails.weight,
        widget.userDetails.height,
        widget.userDetails.email.trim(),
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
      int weight,
      int height,
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
      'weight': weight,
      'height': height,
      'email': email,
      'vegan': isVegan ? 'true' : 'false',
      'vegetarian': isVegetarian ? 'true' : 'false',
      'lactose intolerant': isLactoseIntolerant ? 'true' : 'false',
      'nut allergy': hasNutAllergy ? 'true' : 'false',
      'type II diabetes': hasTypeIIDiabetes ? 'true' : 'false',
      'hypertension': hasHypertension ? 'true' : 'false'
    });
  }
}

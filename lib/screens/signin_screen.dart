import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/main.dart';
import 'package:food_info_app/reusable_widgets/resuable_widget.dart';
import 'package:food_info_app/screens/main_screen.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const SignInScreen({super.key, required this.showRegisterPage});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextController.text.trim(),
            password: _passwordTextController.text.trim())
        .then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainScreen(text: "")));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5448C8),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 170, 20, 130),
            child: Column(
              children: <Widget>[
                logoWidget("assets/barcode-scanner.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  signIn();
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: widget.showRegisterPage,
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => SignUpScreen()));

          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flashcart_new_1/custom_widgets/my_custom_roundedbutton.dart';
import 'package:flashcart_new_1/repository/screens/home/homescreen.dart';
import 'package:flashcart_new_1/repository/screens/splash/splashscreen.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() =>
      _CreateAccountPageState();
}

class _CreateAccountPageState
    extends State<CreateAccountPage> {

  int selectedIndex = 0;

  TextEditingController nameController =
  TextEditingController();

  TextEditingController emailController =
  TextEditingController();

  TextEditingController passwordController =
  TextEditingController();

  bool isPasswordVisible = false;

  // PREMIUM INPUT DECORATION
  InputDecoration customInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {

    return InputDecoration(

      hintText: hint,

      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),

      prefixIcon: Icon(
        icon,
        color: Colors.grey.shade600,
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.grey.shade100,

      contentPadding:
      EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 18,
      ),

      enabledBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide:
        BorderSide(color: Colors.transparent),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide:
        BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide:
        BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide:
        BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  bool isValidEmail(String email) {

    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  bool isValidPassword(String password) {

    return password.length >= 8;
  }

  void showError(String message) {

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Invalid Action"),

          content: Text(message),

          actions: [

            TextButton(

              onPressed: () =>
                  Navigator.pop(context),

              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  Widget getCurrentPage() {

    if (selectedIndex == 0) {
      return steponeUI();
    }

    if (selectedIndex == 1) {
      return steptwoUI();
    }

    return stepthreeUI();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.white,

        leading: InkWell(

          onTap: () {

            if (selectedIndex > 0) {

              selectedIndex--;

              setState(() {});

            } else {

              Navigator.pop(context);
            }
          },

          child: Icon(
            Icons.arrow_back_ios,
            size: 35,
            color: Colors.black,
          ),
        ),

        title: const Padding(

          padding: EdgeInsets.all(50.0),

          child: Text(

            'Create Account',

            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      backgroundColor: Colors.white,

      body: Column(

        children: [

          getCurrentPage(),

          MyCustomRoundedButton(

            onTap: () async {

              // STEP 1
              if (selectedIndex == 0) {

                if (nameController.text
                    .trim()
                    .isEmpty) {

                  showError(
                    "Please enter your name",
                  );

                  return;
                }
              }

              // STEP 2
              if (selectedIndex == 1) {

                if (emailController.text
                    .trim()
                    .isEmpty ||

                    !isValidEmail(
                      emailController.text.trim(),
                    )) {

                  showError(
                    "Please enter a valid email",
                  );

                  return;
                }
              }

              // STEP 3
              if (selectedIndex == 2) {

                if (passwordController.text
                    .isEmpty ||

                    !isValidPassword(
                      passwordController.text,
                    )) {

                  showError(
                    "Password must be at least 8 characters long",
                  );

                  return;
                }

                try {

                  // CREATE USER
                  UserCredential userCredential =
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(

                    email:
                    emailController.text.trim(),

                    password:
                    passwordController.text.trim(),
                  );

                  // SAVE NAME IN AUTH
                  await userCredential.user!
                      .updateDisplayName(

                    nameController.text.trim(),
                  );

                  await userCredential.user!
                      .reload();

                  // SAVE USER DATA IN FIRESTORE
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userCredential.user!.uid)
                      .set({

                    "name":
                    nameController.text.trim(),

                    "email":
                    emailController.text.trim(),

                    "uid":
                    userCredential.user!.uid,
                  });

                  // SAVE LOCALLY
                  final prefs =
                  await SharedPreferences
                      .getInstance();

                  await prefs.setString(
                    "username",
                    nameController.text,
                  );

                  await prefs.setString(
                    "email",
                    emailController.text,
                  );

                  await prefs.setBool(
                    SplashScreenState.KEYLOGIN,
                    true,
                  );

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          HomeScreen(),
                    ),
                  );

                } on FirebaseAuthException catch (e) {

                  if (e.code ==
                      'email-already-in-use') {

                    showError(
                      "Email already registered",
                    );

                  } else if (e.code ==
                      'weak-password') {

                    showError(
                      "Weak password",
                    );

                  } else {

                    showError(
                      e.message ??
                          "Error occurred",
                    );
                  }

                } catch (e) {

                  showError(
                    "Something went wrong",
                  );
                }

                return;
              }

              selectedIndex++;

              setState(() {});
            },

            text:
            selectedIndex < 2
                ? 'Next'
                : 'Create an Account',

            textColor: Colors.black,
            bgColor: Colors.red,

            mWidth:
            selectedIndex < 2
                ? 120
                : 220,

            mHeight: 50,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // STEP 1
  Widget steponeUI() => Padding(

    padding: const EdgeInsets.all(18.0),

    child: Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          "What's your name?",
          style: TextStyle(fontSize: 25),
        ),

        const SizedBox(height: 10),

        TextField(

          controller: nameController,

          decoration: customInputDecoration(

            hint: "Enter your name",
            icon: Icons.person,
          ),
        ),
      ],
    ),
  );

  // STEP 2
  Widget steptwoUI() => Padding(

    padding: const EdgeInsets.all(18.0),

    child: Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          "Enter your email address",
          style: TextStyle(fontSize: 25),
        ),

        const SizedBox(height: 10),

        TextField(

          controller: emailController,

          decoration: customInputDecoration(

            hint: "Enter your email",
            icon: Icons.email,
          ),
        ),
      ],
    ),
  );

  // STEP 3
  Widget stepthreeUI() => Padding(

    padding: const EdgeInsets.all(18.0),

    child: Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          "Create a password",
          style: TextStyle(fontSize: 25),
        ),

        const SizedBox(height: 10),

        TextField(

          controller: passwordController,

          obscureText: !isPasswordVisible,

          decoration: customInputDecoration(

            hint: "Enter your password",

            icon: Icons.lock,

            suffixIcon: IconButton(

              icon: Icon(

                isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,

                color: Colors.grey,
              ),

              onPressed: () {

                setState(() {

                  isPasswordVisible =
                  !isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    ),
  );
}
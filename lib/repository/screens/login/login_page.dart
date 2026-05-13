import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcart_new_1/repository/screens/home/homescreen.dart';
import 'package:flashcart_new_1/repository/screens/splash/splashscreen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,

        leading: IconButton(

          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 32,
          ),
        ),

        title: Text(
          "Login",

          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            SizedBox(height: 15),

            Text(
              "Enter your Email",

              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10),

            // EMAIL FIELD
            Container(

              height: 55,

              decoration: BoxDecoration(

                color: Color(0XFFF2F2F2),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: TextField(

                controller: emailController,

                decoration: InputDecoration(

                  border: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                    size: 28,
                  ),

                  hintText: "Enter your email",

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            Text(
              "Enter your Password",

              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10),

            // PASSWORD FIELD
            Container(

              height: 55,

              decoration: BoxDecoration(

                color: Color(0XFFF2F2F2),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: TextField(

                controller: passwordController,
                obscureText: true,

                decoration: InputDecoration(

                  border: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 28,
                  ),

                  hintText: "Enter your password",

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            Center(

              child: GestureDetector(

                onTap: () async {

                  String email =
                  emailController.text
                      .trim();

                  String password =
                  passwordController.text
                      .trim();

                  // EMPTY CHECK
                  if (email.isEmpty ||
                      password.isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(
                        content: Text(
                          "Please enter email & password",
                        ),
                      ),
                    );

                    return;
                  }

                  try {

                    // LOGIN USER
                    UserCredential userCredential =
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(

                      email: email,
                      password: password,
                    );

                    // REFRESH USER
                    await userCredential.user
                        ?.reload();

                    User? currentUser =
                        FirebaseAuth.instance
                            .currentUser;

                    // HANDLE OLD USERS
                    String userName = "";

                    // IF DISPLAY NAME EXISTS
                    if (currentUser
                        ?.displayName !=
                        null &&
                        currentUser!
                            .displayName!
                            .isNotEmpty) {

                      userName =
                      currentUser.displayName!;

                    } else {

                      // EXTRACT NAME FROM EMAIL
                      userName =
                      email.split("@")[0];

                      // SAVE NAME FOR OLD USERS
                      await currentUser
                          ?.updateDisplayName(
                        userName,
                      );
                    }

                    // SAVE LOGIN STATUS
                    final prefs =
                    await SharedPreferences
                        .getInstance();

                    await prefs.setBool(
                      SplashScreenState.KEYLOGIN,
                      true,
                    );

                    // SAVE USER DATA LOCALLY
                    await prefs.setString(
                      "username",
                      userName,
                    );

                    await prefs.setString(
                      "email",
                      email,
                    );

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(
                        content: Text(
                          "Welcome $userName",
                        ),
                      ),
                    );

                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            HomeScreen(),
                      ),
                    );

                  } on FirebaseAuthException catch (e) {

                    String message =
                        "Login Failed";

                    if (e.code ==
                        'user-not-found') {

                      message =
                      "No user found, please sign up";
                    }

                    else if (e.code ==
                        'wrong-password') {

                      message =
                      "Incorrect password";
                    }

                    else if (e.code ==
                        'invalid-email') {

                      message =
                      "Invalid email format";
                    }

                    else if (e.code ==
                        'invalid-credential') {

                      message =
                      "Invalid email or password";
                    }

                    else if (e.code ==
                        'too-many-requests') {

                      message =
                      "Too many attempts, try later";
                    }

                    else if (e.code ==
                        'user-disabled') {

                      message =
                      "This account is disabled";
                    }

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(
                        content: Text(message),
                      ),
                    );

                  } catch (e) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(
                        content: Text(
                          "Something went wrong",
                        ),
                      ),
                    );
                  }
                },

                child: Container(

                  width: 145,
                  height: 45,

                  decoration: BoxDecoration(

                    color: Color(0XFFD71920),

                    borderRadius:
                    BorderRadius.circular(40),

                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  child: Center(

                    child: Text(
                      "Login",

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
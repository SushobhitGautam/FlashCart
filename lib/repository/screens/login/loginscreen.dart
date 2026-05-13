import 'package:flashcart_new_1/auth_service.dart';
import 'package:flashcart_new_1/custom_widgets/my_custom_roundedbutton.dart';
import 'package:flashcart_new_1/repository/screens/create_account/create_account_page.dart';
import 'package:flashcart_new_1/repository/screens/home/homescreen.dart';
import 'package:flashcart_new_1/repository/screens/login/login_page.dart';
import 'package:flashcart_new_1/repository/widgets/uihelper.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            child: Column(

              children: [

                UiHelper.CustomImage(
                  img: "Blinkit Onboarding Screen.png",
                ),

                SizedBox(height: 30),

                UiHelper.CustomText(
                  text: "India’s last minute app",
                  color: Color(0XFF000000),
                  fontweight: FontWeight.bold,
                  fontsize: 20,
                  fontfamily: "bold",
                ),

                SizedBox(height: 5),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    SizedBox(
                      width: 30,
                      height: 30,

                      child: UiHelper.CustomImage(
                        img: 'cart.jpeg',
                      ),
                    ),

                    SizedBox(width: 5),

                    UiHelper.CustomText(
                      text: "FlashCart",
                      color: Colors.red,
                      fontweight: FontWeight.bold,
                      fontsize: 20,
                      fontfamily: "bold",
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // SIGN UP BUTTON
                MyCustomRoundedButton(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            CreateAccountPage(),
                      ),
                    );
                  },

                  text: 'Sign up',
                  textColor: Colors.white,
                  bgColor: Colors.red,

                  mIconPath:
                  'assets/images/signup logo.webp',
                ),

                SizedBox(height: 20),

                // LOGIN BUTTON
                MyCustomRoundedButton(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(),
                      ),
                    );
                  },

                  text: 'Login',
                  textColor: Colors.white,
                  bgColor: Colors.red,

                  mIconPath:
                  'assets/images/login-removebg-preview.png',
                ),

                SizedBox(height: 20),

                // GOOGLE LOGIN BUTTON
                MyCustomRoundedButton(

                  onTap: () async {

                    final user =
                    await _authService
                        .signInWithGoogle();

                    if (user != null) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        SnackBar(
                          content: Text(
                            "Welcome ${user.email}",
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

                    } else {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        SnackBar(
                          content: Text(
                            "Google Sign-In Failed",
                          ),
                        ),
                      );
                    }
                  },

                  text: 'Login with Google',
                  textColor: Colors.white,
                  bgColor: Colors.red,

                  mIconPath:
                  'assets/images/google2-removebg-preview.png',
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
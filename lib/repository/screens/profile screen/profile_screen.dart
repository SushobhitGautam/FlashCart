import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcart_new_1/repository/screens/home/homescreen.dart';
import 'package:flashcart_new_1/repository/screens/login/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flashcart_new_1/repository/widgets/uihelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcart_new_1/repository/screens/splash/splashscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  String name = "Guest User";
  String email = "No Email";

  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // LOAD USER DATA
  Future<void> loadUserData() async {

    final prefs =
    await SharedPreferences.getInstance();

    // GET CURRENT FIREBASE USER
    User? currentUser =
        FirebaseAuth.instance.currentUser;

    setState(() {

      // GET NAME FROM FIREBASE
      name =
          currentUser?.displayName ??

              prefs.getString("username") ??
              "Guest User";

      // GET EMAIL FROM FIREBASE
      email =
          currentUser?.email ??

              prefs.getString("email") ??
              "No Email";
    });
  }

  // LOGOUT FUNCTION
  Future<void> logoutUser() async {

    final prefs =
    await SharedPreferences.getInstance();

    // FIREBASE LOGOUT
    await FirebaseAuth.instance.signOut();

    // CLEAR LOCAL STORAGE
    await prefs.clear();

    await prefs.setBool(
      SplashScreenState.KEYLOGIN,
      false,
    );

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (context) =>
            LoginScreen(),
      ),

          (route) => false,
    );
  }

  // PICK IMAGE
  Future<void> pickImage() async {

    final XFile? image =
    await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {

        profileImage = File(image.path);
      });
    }
  }

  // EDIT PROFILE DIALOG
  void showEditDialog() {

    TextEditingController nameController =
    TextEditingController(text: name);

    TextEditingController emailController =
    TextEditingController(text: email);

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Edit Profile"),

          content: SingleChildScrollView(

            child: Column(

              children: [

                GestureDetector(

                  onTap: pickImage,

                  child: CircleAvatar(

                    radius: 40,

                    backgroundColor:
                    Colors.grey.shade300,

                    backgroundImage:
                    profileImage != null
                        ? FileImage(profileImage!)
                        : null,

                    child: profileImage == null
                        ? const Icon(
                      Icons.camera_alt,
                      size: 30,
                    )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(

                  controller: nameController,

                  decoration:
                  const InputDecoration(
                    labelText: "Name",
                  ),
                ),

                TextField(

                  controller: emailController,

                  decoration:
                  const InputDecoration(
                    labelText: "Email",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(

              onPressed: () =>
                  Navigator.pop(context),

              child: const Text("Cancel"),
            ),

            ElevatedButton(

              onPressed: () async {

                final prefs =
                await SharedPreferences
                    .getInstance();

                // UPDATE FIREBASE USER NAME
                if (FirebaseAuth
                    .instance
                    .currentUser !=
                    null) {

                  await FirebaseAuth
                      .instance
                      .currentUser!
                      .updateDisplayName(
                    nameController.text,
                  );

                  await FirebaseAuth
                      .instance
                      .currentUser!
                      .verifyBeforeUpdateEmail(
                    emailController.text,
                  );
                }

                setState(() {

                  name =
                      nameController.text;

                  email =
                      emailController.text;
                });

                // SAVE UPDATED DATA
                await prefs.setString(
                  "username",
                  name,
                );

                await prefs.setString(
                  "email",
                  email,
                );

                Navigator.pop(context);
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF7F7F7),

      body: SafeArea(

        child: ListView(

          children: [

            // HEADER
            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              color: Colors.white,

              child: Row(

                children: [

                  // PROFILE IMAGE
                  CircleAvatar(

                    radius: 32,

                    backgroundColor:
                    Colors.black,

                    backgroundImage:
                    profileImage != null
                        ? FileImage(
                      profileImage!,
                    )
                        : null,

                    child: profileImage == null
                        ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // NAME + EMAIL
                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        UiHelper.CustomText(

                          text: name,

                          color: Colors.black,

                          fontweight:
                          FontWeight.bold,

                          fontsize: 16,
                        ),

                        const SizedBox(height: 4),

                        UiHelper.CustomText(

                          text: email,

                          color: Colors.grey,

                          fontweight:
                          FontWeight.w400,

                          fontsize: 13,
                        ),
                      ],
                    ),
                  ),

                  // EDIT BUTTON
                  GestureDetector(

                    onTap: showEditDialog,

                    child: Container(

                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        color:
                        Colors.yellow
                            .shade700,

                        borderRadius:
                        BorderRadius
                            .circular(
                          20,
                        ),
                      ),

                      child: const Text(

                        "Edit",

                        style: TextStyle(
                          fontWeight:
                          FontWeight.w600,

                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SECTION 1
            buildCardSection([

              buildTile(
                Icons.shopping_bag_outlined,
                "My Orders",
              ),

              buildDivider(),

              buildTile(
                Icons.location_on_outlined,
                "Saved Addresses",
              ),

              buildDivider(),

              buildTile(
                Icons.account_balance_wallet_outlined,
                "Wallet",
              ),

              buildDivider(),

              buildTile(
                Icons.payment_outlined,
                "Payment Methods",
              ),
            ]),

            const SizedBox(height: 12),

            // SECTION 2
            buildCardSection([

              buildTile(
                Icons.local_offer_outlined,
                "Offers",
              ),

              buildDivider(),

              buildTile(
                Icons.notifications_none,
                "Notifications",
              ),
            ]),

            const SizedBox(height: 12),

            // SECTION 3
            buildCardSection([

              buildTile(
                Icons.help_outline,
                "Help & Support",
              ),

              buildDivider(),

              buildTile(
                Icons.info_outline,
                "About",
              ),
            ]),

            const SizedBox(height: 12),

            // LOGOUT
            buildCardSection([

              buildTile(

                Icons.logout,
                "Logout",

                isRed: true,

                onTap: logoutUser,
              ),
            ]),

            const SizedBox(height: 20),

            Center(

              child: Text(

                "App version 1.0.0",

                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // CARD WRAPPER
  Widget buildCardSection(
      List<Widget> children) {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(12),
      ),

      child: Column(children: children),
    );
  }

  // TILE
  Widget buildTile(

      IconData icon,
      String title,

      {bool isRed = false,
        VoidCallback? onTap}) {

    return ListTile(

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),

      leading: Icon(

        icon,

        color:
        isRed
            ? Colors.red
            : Colors.black,

        size: 22,
      ),

      title: Text(

        title,

        style: TextStyle(

          fontSize: 14,

          fontWeight: FontWeight.w500,

          color:
          isRed
              ? Colors.red
              : Colors.black,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),

      onTap: onTap,
    );
  }

  // DIVIDER
  Widget buildDivider() {

    return const Divider(
      height: 1,
      thickness: 0.5,
    );
  }
}
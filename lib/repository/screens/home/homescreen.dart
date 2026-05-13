import 'package:flashcart_new_1/repository/screens/profile%20screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcart_new_1/repository/widgets/uihelper.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  int selectedBottomIndex = 0;

  var data = [
    {"img": "image 50.png", "text": "Lights, Diyas \n & Candles"},
    {"img": "image 51.png", "text": "Diwali \n Gifts"},
    {"img": "image 52.png", "text": "Appliances  \n & Gadgets"},
    {"img": "image 53.png", "text": "Home \n & Living"},
    {"img": "supplements Background Removed.png", "text": "Supplements"}
  ];

  var grocerykitchen = [
    {"img": "image 41.png", "text": "Vegetables & \nFruits"},
    {"img": "image 42.png", "text": "Atta, Dal & \nRice"},
    {"img": "image 43.png", "text": "Oil, Ghee & \nMasala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread & \nMilk"},
    {"img": "image 45 (1).png", "text": "Biscuits & \nBakery"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ✅ Animated Page Switch
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: selectedBottomIndex == 0
            ? homeContent()
            : ProfileScreen(),
      ),

      /// ✅ Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomIndex,
        onTap: (index) {
          setState(() {
            selectedBottomIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// ✅ HOME UI
  Widget homeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),

          /// 🔴 HEADER
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Color(0XFFEC0505),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: UiHelper.CustomText(
                        text: "FlashCart",
                        color: Colors.white,
                        fontweight: FontWeight.bold,
                        fontsize: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: UiHelper.CustomText(
                        text: "Delivery in 15 minutes",
                        color: Colors.white,
                        fontweight: FontWeight.bold,
                        fontsize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 20,
                top: 35,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),

              Positioned(
                bottom: 15,
                left: 20,
                right: 20,
                child: UiHelper.CustomTextField(
                    controller: searchController),
              ),
            ],
          ),

          /// 🔥 SALE SECTION
          Container(
            height: 200,
            width: double.infinity,
            color: Color(0XFFEC0505),
            child: Column(
              children: [
                SizedBox(height: 10),
                UiHelper.CustomText(
                  text: "Maha Mega Sale",
                  color: Colors.white,
                  fontweight: FontWeight.bold,
                  fontsize: 20,
                ),

                SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0XFFEAD3D3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              UiHelper.CustomText(
                                text: data[index]["text"].toString(),
                                color: Colors.black,
                                fontweight: FontWeight.bold,
                                fontsize: 10,
                              ),
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: UiHelper.CustomImage(
                                  img: data[index]["img"].toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// 🛒 GROCERY TITLE
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: UiHelper.CustomText(
                text: "Grocery & Kitchen",
                color: Colors.black,
                fontweight: FontWeight.bold,
                fontsize: 14,
              ),
            ),
          ),

          /// 🥦 GROCERY LIST
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: grocerykitchen.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0XFFD9EBEB),
                        ),
                        child: UiHelper.CustomImage(
                          img: grocerykitchen[index]["img"].toString(),
                        ),
                      ),
                      SizedBox(height: 5),
                      UiHelper.CustomText(
                        text: grocerykitchen[index]["text"].toString(),
                        color: Colors.black,
                        fontweight: FontWeight.normal,
                        fontsize: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
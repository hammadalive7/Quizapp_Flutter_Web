import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../core/controller/usercheck_controller.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserCheckController userController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userController = Get.put(UserCheckController());
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Navigator.pushNamed(context, '/LoginScreen');
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text("Enter Quiz Code"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter quiz code";
                } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Please enter valid quiz code";
                }
                return null;
              },
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                icon: Icon(Icons.numbers),
                hintText: "Quiz Code",
              ),
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kPrimaryColor,
              ),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Get.offNamed('/QuizScreen');
                  }
                },
                child: const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            "Quiz App",
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Get.offNamed('/ProfileScreen');
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body:  FutureBuilder(
        future: userController.checkUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome to Quiz App ${userController.user.value.name}!", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                const SizedBox(height: 50),
                _buildBody(),
              ],
            ));
          }
        },
      ),


    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (userController.isAdmin.value) {
        // Admin card
        return SizedBox(
          width: 600,
          child: InkWell(
            onTap: () {
              // Handle admin card tap
            },
            splashColor: kPrimaryColor,
            child: Card(
              surfaceTintColor: kPrimaryColor,
              semanticContainer: true,
              elevation: 15,
              shadowColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 8,
                          child: Image.asset("assets/images/quiz_logo.png"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Create new Quiz",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // User card
        return SizedBox(
          width: 600,
          child: InkWell(
            onTap: () {
              _showDialog();
            },
            splashColor: kPrimaryColor,
            child: Card(
              surfaceTintColor: kPrimaryColor,
              semanticContainer: true,
              elevation: 15,
              shadowColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 8,
                          child: SvgPicture.asset("assets/icons/signup.svg"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Take Quiz Now!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

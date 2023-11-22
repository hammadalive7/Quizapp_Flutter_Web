import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/constants.dart';
import '../../core/controller/profile_controller.dart';
import '../../core/model/user_model.dart';
import '../../core/widgets/Profile Widget/logout_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = Get.put(ProfileController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            onPressed: () => Get.offAllNamed('/HomeScreen'),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title:
         Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset("assets/images/quiz_logo.png")
                  ),
                ),
                const SizedBox(height: 50),

                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                            label: Text("Name"),
                            prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(height: 30 - 20),
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.mail)),
                      ),
                      const SizedBox(height: 30 - 20),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          label:  Text("Password"),
                          prefixIcon:  Icon(Icons.fingerprint),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // -- Form Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.updateUser(
                                UserModel(
                                    name: controller.nameController.text,
                                    email: controller.emailController.text,
                                    password: controller.passwordController.text,
                                    isAdmin: controller.isAdmin.value
                                )
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("Edit Profile",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // -- Logout Button
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: Icons.logout_sharp,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          Get.defaultDialog(
                            title: "LOGOUT",
                            titleStyle: const TextStyle(fontSize: 20),
                            content: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Text("Are you sure, you want to Logout?"),
                            ),
                            confirm: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.Logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                side: BorderSide.none,
                              ),
                              child: const Text("Yes"),
                            ),
                            cancel: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("No"),
                            ),
                          );
                        },
                      )                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

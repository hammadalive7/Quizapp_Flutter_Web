import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class ProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late RxBool isAdmin;

  Rx<UserModel> user = UserModel(name: "", email: "", password: "").obs;

  User? auth;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isAdmin = false.obs;
    auth = FirebaseAuth.instance.currentUser;
    // final auth = FirebaseAuth.instance.currentUser;

    // Fetch user data from Firestore
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        auth = user;
        fetchUserData();
      }
    });  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void fetchUserData() async {
    try {
      String uid = auth!.uid;
      debugPrint("UID: $uid");

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        user.value = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

        nameController.text = user.value.name;
        emailController.text = user.value.email;
        passwordController.text = user.value.password;
        isAdmin = user.value.isAdmin.obs;
      }

      print("User data fetched successfully!");
      print(user.value.toMap());
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void updateUser(UserModel users) async {
    try {
      String uid = auth!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(users.toMap())
          .whenComplete(
              () => Get.snackbar("Updated", "User data updated successfully!"));
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  void Logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();

    // User is not logged in
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId');

    Get.offAllNamed('/LoginScreen');
  }
}

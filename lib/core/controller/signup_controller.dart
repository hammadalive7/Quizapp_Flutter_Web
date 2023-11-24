import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Screens/DashBoard/home_screen.dart';
import 'package:quizapp/core/model/user_model.dart';

import '../../Screens/Login/login_screen.dart';



class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  //Call this Function from Design & it will do the rest
  void registerUser(String email, String password, String name) {
    createUserWithEmailAndPassword(email, password, name);
  }

  final _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');



  Future<String?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // // Email verification
      // await userCredential.user!.sendEmailVerification();
      //
      // // Wait for the user to refresh their data
      // await userCredential.user!.reload();

        Get.snackbar("Successful", "User Registration Successful", duration: const Duration(seconds: 2));

      UserModel user = UserModel(
        name: name,
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _usersCollection.doc(userCredential.user!.uid).set(user.toMap());

        if (userCredential.user != null) {
          // User is logged in
          Get.offAll(() => const LoginScreen());

        //   prefs.setBool('isLoggedIn', true);
        //   prefs.setString('userId', userCredential.user!.uid);
        // } else {
        //   // User is not logged in
        //   prefs.setBool('isLoggedIn', false);
        //   prefs.remove('userId');
        }


    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString(), duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar("Error", e.toString(), duration: const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.onClose();
  }

}
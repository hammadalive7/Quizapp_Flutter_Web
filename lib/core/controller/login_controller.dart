import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/Screens/DashBoard/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  final _auth = FirebaseAuth.instance;

  Future<void> login() async {
    loginWithEmailAndPassword(email.text.trim(), password.text.trim());
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar("Successful", "Login Successful", duration: const Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();

      if (userCredential.user != null) {
        // User is logged in
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userId', userCredential.user!.uid);
      } else {
        // User is not logged in
        prefs.setBool('isLoggedIn', false);
        prefs.remove('userId');
      }


      Get.offAll(() => const HomeScreen());

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
    super.onClose();
  }


}
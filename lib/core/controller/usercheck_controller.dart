

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class UserCheckController extends GetxController{
  static UserCheckController get instance => Get.find();

  Rx<UserModel> user = UserModel(name: "", email: "", password: "").obs;
  RxBool isAdmin = false.obs;

  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  User? auth;

  @override
  void onInit() {
    super.onInit();

    // Fetch user data from Firestore
    auth = FirebaseAuth.instance.currentUser;

    ever(isAdmin, (_) {
      // Trigger a re-build of the widget tree when isAdmin changes
      update();
    });
    // Fetch user data from Firestore
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        auth = user;
         checkUser();
      }
    });
  }

  Future<void> checkUser() async {
    try {
      final userId = auth!.uid;
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();

      if (userDoc.exists) {
        user.value = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        isAdmin.value = user.value.isAdmin;
        print("isAdmin: " + isAdmin.value.toString());
      } else {
        isAdmin.value = false;
      }
    } catch (e) {
      isAdmin.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}